super: self:
let
  erlangManifest = builtins.fromJSON (builtins.readFile ./erlang-manifest.json);

  erlangDerivations =
    builtins.map erlangManifestEntryToDerivation erlangManifest;

    erlangManifestEntryToDerivation = { version, rev }:
    let
      name = "erlang-" + (builtins.replaceStrings ["."] ["-"] version);
    in
    {
      inherit name;
      value = {
        inherit version rev;
      };
    };

  allDerivations = erlangDerivations;

  result = builtins.listToAttrs allDerivations;

in
  result
