#
# Changes from version in nixpkgs:
# - Elixir/LFE support removed (at least for the time being).
# - Changed to take self/super
#
self: super:

rec {

  /* Similar to callPackageWith/callPackage, but without makeOverridable
  */
  callPackageWith = autoArgs: fn: args:
    let
      f = if super.pkgs.lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (super.lib.functionArgs f) autoArgs;
    in f (auto // args);

  callPackage = callPackageWith self.pkgs;

  /* Uses generic-builder to evaluate provided drv containing OTP-version
  specific data.

  drv: package containing version-specific args;
  builder: generic builder for all Erlang versions;
  args: arguments merged into version-specific args, used mostly to customize
        dependencies;

  Arguments passed to the generic-builder are overridable, used to
  enable/disable high-level OTP features, like ODBC or WX support;

  Please note that "mkDerivation" defined here is the one called from R16.nix
  and similar files.
  */
  callErlang = drv: args:
    let
      builder = callPackage ../../development/interpreters/erlang/generic-builder.nix args;
    in
      callPackage drv {
        mkDerivation = super.pkgs.makeOverridable builder;
      };
}
