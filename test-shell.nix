let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };
in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    nixerl.erlang-22-3.erlang
    nixerl.erlang-22-3.rebar3
  ];
}
