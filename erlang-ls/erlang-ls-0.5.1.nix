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

  version = "0.5.1";

  src = fetchFromGitHub {
    owner  = "erlang-ls";
    repo   = "erlang_ls";
    rev    = "${version}";
    sha256 = "1xs9caycxjd7fcgmac0nm746kywy8aygdg0ipfrbwvjx5rcr0b14";
  };

  deps = fetchRebar3Deps {
    inherit name version;
    src = "${src}/rebar.lock";
    sha256 = "03f15nz22njhmypdwsch65rqmdz86mgpkgs6xw5sj45w7r0clq5z";
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
