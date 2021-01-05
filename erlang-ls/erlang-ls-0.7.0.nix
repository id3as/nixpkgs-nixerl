{ stdenv
, fetchFromGitHub
, fetchHex
, erlang
, rebar3
, buildRebar3
, fetchRebar3Deps
, tree
}:

let
  name = "erlang_ls";

  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "erlang-ls";
    repo = "erlang_ls";
    rev = "${version}";
    sha256 = "1gdrn3n264vj7i1j3klwsyl8r19b3qbkid4kbqys5dgg1aj0jrar";
  };

  deps = fetchRebar3Deps {
    inherit name version;
    src = "${src}/rebar.lock";
    sha256 = "0b05ysvrp34kf7fbcg7xjy8ln56kspp0dhjvc8ppv5ncnayzjfsv";
  };

in
  buildRebar3 rec {
    inherit name version src;

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
