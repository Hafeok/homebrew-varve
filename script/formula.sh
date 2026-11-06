#!/usr/bin/env bash
# Writes Formula/varve.rb for one release of Hafeok/Varve (Varve ADR 0226
# point 3), from the release's SHA256SUMS, which the caller has checked and
# whose archives' attestations it has verified.
#
#   script/formula.sh <tag> <SHA256SUMS> [owner/name] > Formula/varve.rb
set -euo pipefail
tag="$1"
sums="$2"
repository="${3:-Hafeok/Varve}"
version="${tag#v}"

sha() {
  local asset="varve-$version-$1.tar.gz"
  local line
  line=$(awk -v asset="$asset" '$2 == asset || $2 == "*" asset { print $1 }' "$sums")
  if [ -z "$line" ]; then echo "$asset is not in $sums" >&2; exit 1; fi
  echo "$line"
}

url() { echo "https://github.com/$repository/releases/download/$tag/varve-$version-$1.tar.gz"; }

# Every SHA-256 first, outside the heredoc, so that a missing archive stops
# the script before a line is written.
osx_arm64=$(sha osx-arm64)
osx_x64=$(sha osx-x64)
linux_arm64=$(sha linux-arm64)
linux_x64=$(sha linux-x64)

cat <<RUBY
# Written by script/formula.sh for $tag of $repository. Do not edit by hand:
# the workflow rewrites it from each release (Varve ADR 0226).
class Varve < Formula
  desc "Event-sourced RDF store and SPARQL 1.1/1.2 engine: the server and the CLI"
  homepage "https://github.com/$repository"
  version "$version"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "$(url osx-arm64)"
      sha256 "$osx_arm64"
    end
    on_intel do
      url "$(url osx-x64)"
      sha256 "$osx_x64"
    end
  end

  on_linux do
    on_arm do
      url "$(url linux-arm64)"
      sha256 "$linux_arm64"
    end
    on_intel do
      url "$(url linux-x64)"
      sha256 "$linux_x64"
    end
  end

  def install
    bin.install "varve"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/varve --version")
  end
end
RUBY
