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
    (nixerl.erlang-23-0.erlang.overrideAttrs (oldAttrs: rec {
			enableParallelBuilding = true;
		}))

    nixerl.erlang-22-3.rebar3
  ];
}
