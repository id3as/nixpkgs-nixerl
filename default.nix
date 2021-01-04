self: super:
let
  fetchRebar3Deps = (import ./_support/fetch-rebar3-deps.nix);

  rebar3-13 = (import ./rebar3/rebar3-13.nix);
  rebar3-14 = (import ./rebar3/rebar3-14.nix);
  erlang-ls-0-7-0 = (import ./erlang-ls/erlang-ls-0.7.0.nix);

  erlangManifest = builtins.fromJSON (builtins.readFile ./erlang-manifest.json);

  erlangReleases =
    builtins.map erlangManifestEntryToRelease erlangManifest;

  erlangManifestEntryToRelease = { version, rev, sha256 }@args:
    {
      name = "erlang-" + (builtins.replaceStrings ["."] ["-"] version);
      value = buildPackages args;
    };

  buildPackages = { version, rev, sha256 }:
    let
      majorVersion = super.lib.versions.major version;
    in
      if majorVersion == "17" then
        # Unsupported, but seems to work
        rec {
          erlang = self.beam.interpreters.erlangR18.override { inherit version sha256; };
          rebar3 = self.beam.packages.erlang.rebar3.override { inherit erlang; };
        }
      else if majorVersion == "18" then
        rec {
          erlang = self.beam.interpreters.erlangR18.override { inherit version sha256; };
          rebar3 = self.beam.packages.erlang.rebar3.override { inherit erlang; };
        }
      else if majorVersion == "19" then
        rec {
          erlang = self.beam.interpreters.erlangR19.override { inherit version sha256; };
          rebar3 = self.beam.packages.erlang.rebar3.override { inherit erlang; };
        }
      else if majorVersion == "20" then
        rec {
          erlang = self.beam.interpreters.erlangR20.override { inherit version sha256; };
          rebar3 = self.beam.packages.erlang.rebar3.override { inherit erlang; };
        }
      else if majorVersion == "21" then
        rec {
          erlang = self.beam.interpreters.erlangR21.override { inherit version sha256; };
          rebar3 = self.beam.packages.erlang.rebar3.override { inherit erlang; };
        }
      else if majorVersion == "22" then
        rec {
          erlang = self.beam.interpreters.erlangR22.override { inherit version sha256; };
          rebar3 = super.callPackage rebar3-14 { inherit erlang; };
          erlang-ls = super.callPackage erlang-ls-0-7-0 {
            inherit erlang rebar3;
            buildRebar3 = self.beam.packages.erlang.buildRebar3.override { inherit erlang rebar3; };
            fetchRebar3Deps = super.callPackage fetchRebar3Deps { inherit rebar3; };
          };
        }
      else if majorVersion == "23" then
        # NOTE: nixpkgs doesn't have an R23 yet, but R22 works just fine as a base
        # NOTE: need a newer rebar3 than is in nixpkgs
        rec {
          erlang = self.beam.interpreters.erlangR22.override { inherit version sha256; };
          rebar3 = super.callPackage rebar3-14 { inherit erlang; };
          erlang-ls = super.callPackage erlang-ls-0-7-0 {
            inherit erlang rebar3;
            buildRebar3 = self.beam.packages.erlang.buildRebar3.override { inherit erlang rebar3; };
            fetchRebar3Deps = super.callPackage fetchRebar3Deps { inherit rebar3; };
          };
        }
      else
        throw ("nixerl does not currently have support for Erlang with major version: " + majorVersion);

in
  {
    nixerl = (super.nixerl or {}) // (builtins.listToAttrs erlangReleases);
  }
