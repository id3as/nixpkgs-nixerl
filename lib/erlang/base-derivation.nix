{ version
, rev
, mkDerivation
, fetchpatch
, lib
, pkgs
}:
let
  inherit (lib) versions;

  # From development/beam-modules/lib.nix:
  # Similar to callPackageWith/callPackage, but without makeOverridable
  callPackageWith = autoArgs: fn: args:
    let
      auto = builtins.intersectAttrs (stdenv.lib.functionArgs fn) autoArgs;
    in
    fn (auto // args);

  callPackage = callPackageWith pkgs;

  genericBuilder = callPackage (import ./support/generic-builder.nix) {};

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


