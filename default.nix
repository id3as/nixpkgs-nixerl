self: super:
let
  erlangLib = (import ./lib/imported-from-nixpkgs/development/beam-modules/lib.nix) self super;

  erlangManifest = builtins.fromJSON (builtins.readFile ./erlang-manifest.json);

  erlangReleases =
    builtins.map erlangManifestEntryToRelease erlangManifest;

  erlangManifestEntryToRelease = { version, rev }@args:
    let
      name = "release-" + (builtins.replaceStrings ["."] ["-"] version);

      erlangDerivation = erlangManifestEntryToDerivation args;

      rebar3Derivations = [];

      allDerivations = [ { name = "erlang"; value = erlangDerivation; } ] ++ rebar3Derivations;
    in
    {
      inherit name;
      value = builtins.listToAttrs allDerivations;
    };

  erlangManifestEntryToDerivation = { version, rev }:
    let
      majorVersion = super.lib.versions.major version;

      baseDerivation =
        if majorVersion == "18" then
          erlangLib.callErlang ./lib/imported-from-nixpkgs/development/interpreters/erlang/R18.nix {
            wxGTK = self.wxGTK30;
            openssl = self.openssl_1_0_2;
          }
        else if majorVersion == "19" then
          {}
        else if majorVersion == "20" then
          {}
        else if majorVersion == "21" then
          {}
        else if majorVersion == "22" then
          {}
        else
          throw ("nixerl does not currently have support for Erlang with major version: " + majorVersion);
    in
    baseDerivation.override { inherit version; };

in
  {
    erlang-releases = (super.erlang-releases or {}) // (builtins.listToAttrs erlangReleases);
  }
