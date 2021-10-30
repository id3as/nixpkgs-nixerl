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

  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "erlang-ls";
    repo = "erlang_ls";
    rev = "${version}";
    sha256 = "1cw5j19wff7c1za1j1pi53dx29swbrq0k7fnhq979wfw0y95fckk";
  };

  deps = fetchRebar3Deps {
    inherit name version;
    src = "${src}/rebar.lock";
    sha256 = "1v9mmh0cvsdw25v01dg6va776hwv78jc3ciaxk3ykcn5r9yk7fzj";
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
