let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };

  erlangChannel = nixpkgs.nixerl.erlang-23-2-1.overrideScope' (self: super: {
    erlang = super.erlang.override {
      wxSupport = false;
    };
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
