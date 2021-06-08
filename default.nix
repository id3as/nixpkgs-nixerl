self: super:
let
  fetchRebar3Deps = (import ./_support/fetch-rebar3-deps.nix);

  # Erlang 19 - 22
  rebar3-13 = (import ./rebar3/rebar3-13.nix);
  # Erlang 19 - 23
  rebar3-15 = (import ./rebar3/rebar3-15.nix);
  # Erlang 22 - 24
  rebar3-16 = (import ./rebar3/rebar3-16.nix);

  erlang-ls-0-13-0 = (import ./erlang-ls/erlang-ls-0.13.0.nix);

  beam = (import ./lib/imported-from-nixpkgs/development/beam-modules/lib.nix) self super;
  erlang18 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R18.nix) {};
  erlang19 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R19.nix) {};
  erlang20 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R20.nix) {};
  erlang21 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R21.nix) {};
  erlang22_24 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R22-24.nix) {};

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
      if majorVersion == "19" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang19.override { inherit version sha256; };
            rebar3 = scope.callPackage rebar3-15 {};
          })
      else if majorVersion == "20" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang20.override { inherit version sha256; };
            rebar3 = scope.callPackage rebar3-15 {};
          })
      else if majorVersion == "21" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang21.override { inherit version sha256; };
            rebar3 = scope.callPackage rebar3-15 {};
          })
      else if majorVersion == "22" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang22_24.override { inherit version sha256; };

            rebar3 = scope.callPackage rebar3-16 {};

            erlang-ls = scope.callPackage erlang-ls-0-13-0 {};

            buildRebar3 = scope.callPackage ({erlang, rebar3}: self.beam.packages.erlang.buildRebar3.override {
              inherit erlang rebar3;
            }) {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else if majorVersion == "23" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang22_24.override { inherit version sha256; };

            rebar3 = scope.callPackage rebar3-16 {};

            erlang-ls = scope.callPackage erlang-ls-0-13-0 {};

            buildRebar3 = scope.callPackage ({erlang, rebar3}: self.beam.packages.erlang.buildRebar3.override {
              inherit erlang rebar3;
            }) {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else if majorVersion == "24" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang22_24.override { inherit version sha256; };

            rebar3 = scope.callPackage rebar3-16 {};

            erlang-ls = scope.callPackage erlang-ls-0-13-0 {};

            buildRebar3 = scope.callPackage ({erlang, rebar3}: self.beam.packages.erlang.buildRebar3.override {
              inherit erlang rebar3;
            }) {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else
        throw ("nixerl does not currently have support for Erlang with major version: " + majorVersion);
in
  {
    nixerl = (super.nixerl or {}) // (builtins.listToAttrs erlangReleases);
  }
