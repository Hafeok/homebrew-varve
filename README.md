# homebrew-varve

The Homebrew tap of [Varve](https://github.com/Hafeok/Varve): an
event-sourced RDF store and SPARQL 1.1/1.2 engine, as a server and a command
line.

```sh
brew install hafeok/varve/varve
varve --version
```

It installs the Native AOT binary of the release, for macOS (arm64, Intel)
and Linux (x64, arm64). Until Varve 1.0 it follows the newest preview.

## How the formula is kept

`Formula/varve.rb` is written by `.github/workflows/update.yml`, never by
hand (Varve ADR 0226):

1. Every six hours, and on demand, it picks the release: the newest,
   prereleases included, until a 1.0.0 or later exists, then the newest
   stable one (`script/pick-release.sh`).
2. It downloads the four archives and `SHA256SUMS`, checks each archive
   against the list, and verifies each archive's build provenance: made by
   Varve's `publish.yml`, for that tag.
3. It writes the formula from the verified list (`script/formula.sh`).
4. It installs and tests the formula on macOS arm64, macOS Intel and Linux.
5. Only then does it commit, with this repository's own token.

Varve's workflows never push here, and no token crosses repositories.

To verify a binary yourself:

```sh
gh attestation verify varve-<version>-osx-arm64.tar.gz --repo Hafeok/Varve --source-ref refs/tags/v<version>
```

The formula is MPL-2.0, like Varve.
