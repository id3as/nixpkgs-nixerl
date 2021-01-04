let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };

  erlangChannel = nixpkgs.nixerl.erlang-23-2-1;
in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    erlangChannel.erlang
    erlangChannel.rebar3
    erlangChannel.erlang-ls
  ];
}
