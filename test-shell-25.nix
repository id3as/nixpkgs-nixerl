let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };


  erlang = nixpkgs.nixerl.erlang-25-0.overrideScope' (self: super: {
    erlang = super.erlang.override {
#      wxSupport = false;
    };
  });
in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    erlang.erlang
    erlang.rebar3
    erlang.erlang-ls
  ];
}
