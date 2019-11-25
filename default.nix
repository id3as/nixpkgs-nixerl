self: super:
let
  erlangLib = (import ./lib/imported-from-nixpkgs/development/beam-modules/lib.nix) self super;

  erlangManifest = builtins.fromJSON (builtins.readFile ./erlang-manifest.json);

  erlangReleases =
    builtins.map erlangManifestEntryToRelease erlangManifest;

  erlangManifestEntryToRelease = { version, rev }@args:
    let
      name = "erlang-" + (builtins.replaceStrings ["."] ["-"] version);

      erlangDerivation = erlangManifestEntryToDerivation args;

      allDerivations = [
        { name = "erlang"; value = erlangDerivation; }
        { name = "rebar3"; value = self.beam.packages.erlang.rebar3.override{ erlang = erlangDerivation; }; }
      ];
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
          self.beam.interpreters.erlangR18
        else if majorVersion == "19" then
          self.beam.interpreters.erlangR19
        else if majorVersion == "20" then
          self.beam.interpreters.erlangR20
        else if majorVersion == "21" then
          self.beam.interpreters.erlangR21
        else if majorVersion == "22" then
          self.beam.interpreters.erlangR22
        else
          throw ("nixerl does not currently have support for Erlang with major version: " + majorVersion);
    in
    baseDerivation.override { inherit version; };

in
  {
    nixerl = (super.nixerl or {}) // (builtins.listToAttrs erlangReleases);
  }
