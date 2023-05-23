{ stdenv
, fetchFromGitHub
, fetchHex
, erlang
, rebar3
, buildRebar3
, fetchRebar3Deps
, tree
, git
}:

let
  name = "erlang_ls";

  ls_version = "229175ec35afddbb5c5a0ac2cf25423d7aa0b6ab";
  ls_sha256 = "153rz684gg51np53c1cqinwv1ps1l0mjf6vbsqn7q53z4py17j4y";
  deps_sha256 = "1jc7p9jkhj13qa0cc2qv3h6s0r2jz5mlvm8jwhjyzs5i91rrpgnj";

  src = fetchFromGitHub {
    owner = "id3as";
    repo = "erlang_ls";
    rev = "${ls_version}";
    sha256 = "${ls_sha256}";
  };

  deps = fetchRebar3Deps {
    inherit name;
    version = "${ls_version}";
    src = "${src}/rebar.lock";
    sha256 = "${deps_sha256}";
  };

in
  buildRebar3 rec {
    inherit name src;
    version = "${ls_version}";

    # These  have to be copies rather than
    # symlinks  because priv gets written to a lot
    configurePhase = ''
     runHook preConfigure

     mkdir -p _checkouts
     cp --no-preserve=mode -R ${deps}/_checkouts/* _checkouts/

     runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      HOME=. make all
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp _build/default/bin/erlang_ls $out/bin/erlang_ls
    '';

    meta = {
      homepage = "https://github.com/erlang-ls/erlang_ls";
      description = "Erlang language server";
    };
}
