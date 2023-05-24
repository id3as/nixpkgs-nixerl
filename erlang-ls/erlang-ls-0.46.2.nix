{ stdenv
, lib
, fetchFromGitHub
, fetchHex
, fetchgit
, erlang
, rebar3
, buildRebar3
, tree
, git
}:

let
  name = "erlang_ls";

  ls_version = "0.46.2";
  ls_sha256 = "07wh3dzpha3ksbbmkw1iqn4fzz3y5jbg98wnzkwa9z1grzr1li17";
  deps_sha256 = "1jc7p9jkhj13qa0cc2qv3h6s0r2jz5mlvm8jwhjyzs5i91rrpgnj";

  src = fetchFromGitHub {
    owner = "erlang-ls";
    repo = "erlang_ls";
    rev = "${ls_version}";
    sha256 = "${ls_sha256}";
  };

  deps = import ./erlang-ls-0.46.2-deps.nix {
    inherit fetchHex fetchFromGitHub fetchgit;
    builder = buildRebar3;
    overrides = (self: super: {
      proper = super.proper.overrideAttrs (_: {
        configurePhase = "true";
      });
      redbug = super.redbug.overrideAttrs (_: {
        patchPhase = ''
          substituteInPlace rebar.config --replace ", warnings_as_errors" ""
          '';
      });
    });
  };
  beamDeps = lib.concatStringsSep " " (builtins.attrValues deps);

in
  buildRebar3 rec {
    inherit name src;
    version = "${ls_version}";

    # These  have to be copies rather than
    # symlinks  because priv gets written to a lot
    configurePhase = ''
     runHook preConfigure
     mkdir -p _checkouts
     mkdir -p _build/default/lib
     for i in ${beamDeps}; do
       j=$(echo $(basename $i) | sed 's/-[^-]*$//' | sed 's/[^-]*-//')
       cp --no-preserve=mode -R $i/lib/erlang/lib/* _checkouts/$j
       cp --no-preserve=mode -R $i/lib/erlang/lib/* _build/default/lib/$j
     done
     runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      ERL_LIBS=$(pwd)/_build/default/lib REBAR_IGNORE_DEPS=1 HOME=. make all
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
