let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };

  erlangChannel = nixpkgs.nixerl.erlang-22-3;
in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    erlangChannel.erlang
    erlangChannel.rebar3
    erlangChannel.erlang-ls
  ];
}
