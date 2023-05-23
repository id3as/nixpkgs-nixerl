self: super:
let
  autoconf = if super ? autoconf269 then super.autoconf269 else super.autoconf;

  fetchRebar3Deps = (import ./_support/fetch-rebar3-deps.nix);

  # Erlang 19 - 22 Default
  rebar3-13 = (import ./rebar3/rebar3-13.nix);

  # Erlang 19 - 23 Default
  rebar3-15 = (import ./rebar3/rebar3-15.nix);

  # Erlang 22 - 24 Compatible
  rebar3-16 = (import ./rebar3/rebar3-16.nix);

  # Erlang 22 - 24 Default
  rebar3-17 = (import ./rebar3/rebar3-17.nix);

  # Erlang 26 Default
  rebar3-21 = (import ./rebar3/rebar3-21.nix);

  erlang-ls-0-20-0 = (import ./erlang-ls/erlang-ls-0.20.0.nix);

  erlang-ls-0-46-2 = (import ./erlang-ls/erlang-ls-0.46.2.nix);

  beam = (import ./lib/imported-from-nixpkgs/development/beam-modules/lib.nix) self super;

  erlang18 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R18.nix) {
    inherit autoconf;
  };

  erlang19 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R19.nix) {
    inherit autoconf;
  };

  erlang20 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R20.nix) {
    inherit autoconf;
  };

  erlang21 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R21.nix) {
    inherit autoconf;
  };

  erlang22_24 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R22-24.nix) {
    inherit autoconf;
    parallelBuild = true;
  };

  erlang25 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R25.nix) {
    inherit autoconf;
    parallelBuild = true;
  };

  erlang26 = beam.callErlang (import lib/imported-from-nixpkgs/development/interpreters/erlang/R26.nix) {
    inherit autoconf;
    parallelBuild = true;
  };

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

            rebar3_16 = scope.callPackage rebar3-16 {};
            rebar3 = scope.callPackage rebar3-17 {};

            erlang-ls = scope.callPackage erlang-ls-0-20-0 {};

            # Needed by erlang-ls
            pc = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/pc/default.nix) {};
            buildRebar3 = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/build-rebar3.nix) {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else if majorVersion == "23" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang22_24.override { inherit version sha256; };

            rebar3_16 = scope.callPackage rebar3-16 {};
            rebar3 = scope.callPackage rebar3-17 {};

            # Needed by erlang-ls
            pc = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/pc/default.nix) {};
            buildRebar3 = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/build-rebar3.nix) {};

            erlang-ls = scope.callPackage erlang-ls-0-20-0 {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else if majorVersion == "24" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang22_24.override { inherit version sha256; };

            rebar3_16 = scope.callPackage rebar3-16 {};
            rebar3 = scope.callPackage rebar3-17 {};

            # Needed by erlang-ls
            pc = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/pc/default.nix) {};
            buildRebar3 = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/build-rebar3.nix) {};

            erlang-ls = scope.callPackage erlang-ls-0-20-0 {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else if majorVersion == "25" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope: {
            erlang = erlang25.override { inherit version sha256; };

            rebar3_16 = scope.callPackage rebar3-16 {};
            rebar3 = scope.callPackage rebar3-17 {};

            # Needed by erlang-ls
            pc = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/pc/default.nix) {};
            buildRebar3 = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/build-rebar3.nix) {};

            erlang-ls = scope.callPackage erlang-ls-0-20-0 {};

            fetchRebar3Deps = scope.callPackage fetchRebar3Deps {};
          })
      else if majorVersion == "26" then
        let
          newScope = extra: super.lib.callPackageWith (super // extra);
        in
          super.lib.makeScope newScope (scope:
            let
              rebar3 = scope.callPackage rebar3-21 {};
            in
            {
              erlang = erlang26.override { inherit version sha256; };

              rebar3 = rebar3;

              # Needed by erlang-ls
              #pc = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/pc/default.nix) {};
              buildRebar3 = scope.callPackage (import ./lib/imported-from-nixpkgs/development/beam-modules/build-rebar3.nix) {};

              erlang-ls = scope.callPackage erlang-ls-0-46-2 {};

              fetchRebar3Deps = scope.callPackage fetchRebar3Deps { rebar3 = rebar3.rebar3; };
          })
      else
        throw ("nixerl does not currently have support for Erlang with major version: " + majorVersion);
in
  {
    nixerl = (super.nixerl or {}) // (builtins.listToAttrs erlangReleases);
  }
