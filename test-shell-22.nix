let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };
  erlangChannel = nixpkgs.nixerl.erlang-22-2-1.overrideScope' (self: super: {
#    erlang = super.erlang.overrideAttrs(attr:  {
#      wxSupport = false;
#      configureFlags = [
#        "--without-wx"
#      ]; # bleh
    });
  });

in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    erlangChannel.erlang
    erlangChannel.rebar3
    erlangChannel.erlang-ls
  ];
}
