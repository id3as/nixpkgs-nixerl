{ version
, rev
, mkDerivation
, fetchpatch
, lib
, pkgs
}:
let
  inherit (lib) versions;

  versionSpecificBuilders = {
    "18" = import ./support/R18.nix { mkDerivation = genericBuilder; inherit fetchpatch; };
    "19" = import ./support/R19.nix { mkDerivation = genericBuilder; inherit fetchpatch; };
    "20" = import ./support/R20.nix { mkDerivation = genericBuilder; };
    "21" = import ./support/R21.nix { mkDerivation = genericBuilder; };
    "22" = import ./support/R22.nix { mkDerivation = genericBuilder; };
  };

  majorVersion = versions.major version;

  versionSpecificBuilder = builtins.getAttr majorVersion versionSpecificBuilders;

  result = "";
in
  result


