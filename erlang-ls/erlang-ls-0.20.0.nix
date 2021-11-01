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

  ls_version = "81086c957274069e66ab8b396c8af7c5ac9c92ed";
  ls_sha256 = "0ybdgj01y1wykgj5bg8yi15an08lx0i2bdlx5s9r4qhimkdvbgsv";
  deps_sha256 = "0z1yi6s5601ij8gl5ykyfkl7wjba781w79yh3cm8xizkcd2qyyvn";

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
