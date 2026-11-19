# Written by script/formula.sh for v0.1.0-preview.22 of Hafeok/Varve. Do not edit by hand:
# the workflow rewrites it from each release (Varve ADR 0226).
class Varve < Formula
  desc "Event-sourced RDF store and SPARQL 1.1/1.2 engine: the server and the CLI"
  homepage "https://github.com/Hafeok/Varve"
  version "0.1.0-preview.22"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Hafeok/Varve/releases/download/v0.1.0-preview.22/varve-0.1.0-preview.22-osx-arm64.tar.gz"
      sha256 "788f5bc72fe22621b3559079fbf5abf1f746c1f73d4a55bde00c9c92cea0e4e8"
    end
    on_intel do
      url "https://github.com/Hafeok/Varve/releases/download/v0.1.0-preview.22/varve-0.1.0-preview.22-osx-x64.tar.gz"
      sha256 "7e1b823d554c116705437f60155555596e53383a13f4ec59905dc9bf0ac3811e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hafeok/Varve/releases/download/v0.1.0-preview.22/varve-0.1.0-preview.22-linux-arm64.tar.gz"
      sha256 "135bcdd14fb1ce8a7f10a64b9a58d528bc773e40ed3d76325b72deebd3c44a68"
    end
    on_intel do
      url "https://github.com/Hafeok/Varve/releases/download/v0.1.0-preview.22/varve-0.1.0-preview.22-linux-x64.tar.gz"
      sha256 "270c15a144f716ced627542923b0711a8b443b0211e89dba686cb30571dc8166"
    end
  end

  def install
    bin.install "varve"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/varve --version")
  end
end
