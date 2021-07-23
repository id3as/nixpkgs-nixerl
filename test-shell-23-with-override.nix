let
  # pinnedNix =
  #   builtins.fetchGit {
  #     name = "nixpkgs-pinned";
  #     url = "https://github.com/NixOS/nixpkgs.git";
  #     # rev = "e5f945b13b3f6a39ec9fbb66c9794b277dc32aa1";
  #     rev = "10f33d0d3b879c6f2ca5a424d02e242985545dec";
  #   };

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
