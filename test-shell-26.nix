let

  pinnedNixHash = "b7fc729117a70d0df9e9adfc624662148e32ca0a";

  pinnedNix =
    builtins.fetchGit {
      name = "nixpkgs-pinned";
      url = "https://github.com/NixOS/nixpkgs.git";
      rev = "${pinnedNixHash}";
    };

  nixpkgs =
    import pinnedNix {
      overlays = [
        (import ./.)
      ];
    };


  erlang = nixpkgs.nixerl.erlang-26-1.overrideScope' (self: super: {
    erlang = (super.erlang.override {
#      wxSupport = false;
    });
  });
in

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    erlang.erlang
    erlang.rebar3.rebar3
    erlang.erlang-ls
  ];
}
