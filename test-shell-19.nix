let
  nixpkgs =
    import <nixpkgs> {
      overlays = [
        (import ./.)
      ];
    };

  erlangChannel = nixpkgs.nixerl.erlang-19-3-6-9;
in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    (erlangChannel.erlang.override { wxSupport = false; })
    # erlangChannel.rebar3
  ];
}
