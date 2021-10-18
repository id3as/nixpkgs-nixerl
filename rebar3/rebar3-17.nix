# NOTE: this has been imported from https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/build-managers/rebar3/default.nix

{ stdenv
, fetchFromGitHub
, fetchHex
, erlang
, tree
, git
, makeWrapper
, lib
}:

let
  version = "3.17.0";

  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.5.0";
    sha256 = "3e7c6fb2ba4c29b0dd5dfe9d031b66449e2088ecec1a81465bd9fde05ed7d0db";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.6";
    sha256 = "bdb0d2471f453c88ff3908e7686f86f9be327d065cc1ec16fa4540197ea04680";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.6.1";
    sha256 = "524c97b4991b3849dd5c17a631223896272c6b0af446778ba4675a1dff53bb7e";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.8.1";
    sha256 = "e45745ade9c476a9a469ea0840e418ab19360dc44f01a233304e118a44486ba0";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "1.0.1";
    sha256 = "53e1ab83b9ceb65c9672d3e7a35b8092e9bdc9b3ee80721471a161c10c59959c";
  };
  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.10.0";
    sha256 = "43effa3fd4bb9523157af5a9e2276c493495b8459fc8737144aa186cb13ce2ee";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "4.5.0";
    sha256 = "0lic41rc5a2grg1z78wqcr3i6wnx2rc94pkjlbsn7jp6rhh8zdfx";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.3.1";
    sha256 = "315e8d447d3a4b02bcdbfa397ad03bbb988a6e0aa6f44d3add0f4e3c3bf97672";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.5.1";
    sha256 = "686541a22efe6ca5a41a047b39516c2dd28fb3cade5f24a2f19145b3967f9d80";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.5.0";
    sha256 = "d6c8ba213424944e6e05bbc097c32001cdd0abe3925d02454f229b20d68763c9";
  };

in
stdenv.mkDerivation rec {
  pname = "rebar3";
  inherit version erlang;

  src = fetchFromGitHub {
    owner = "erlang";
    repo = pname;
    rev = version;
    sha256 = "02sk3whrbprzlih4pgcsd6ngmassfjfmkz21gwvb7mq64pib40k6";
  };

  buildInputs = [ erlang tree git makeWrapper ];

  postPatch = ''
    mkdir -p _checkouts
    mkdir -p _build/default/lib/

    cp --no-preserve=mode -R ${bbmustache} _checkouts/bbmustache
    cp --no-preserve=mode -R ${certifi} _checkouts/certifi
    cp --no-preserve=mode -R ${cf} _checkouts/cf
    cp --no-preserve=mode -R ${cth_readable} _checkouts/cth_readable
    cp --no-preserve=mode -R ${erlware_commons} _checkouts/erlware_commons
    cp --no-preserve=mode -R ${eunit_formatters} _checkouts/eunit_formatters
    cp --no-preserve=mode -R ${getopt} _checkouts/getopt
    cp --no-preserve=mode -R ${providers} _checkouts/providers
    cp --no-preserve=mode -R ${relx} _checkouts/relx
    cp --no-preserve=mode -R ${ssl_verify_fun} _checkouts/ssl_verify_fun

    # Bootstrap script expects the dependencies in _build/default/lib
    # TODO: Make it accept checkouts?
    for i in _checkouts/* ; do
        ln -s $(pwd)/$i $(pwd)/_build/default/lib/
    done
  '';

  buildPhase = ''
    HOME=. escript bootstrap
  '';

  installPhase = ''
    mkdir -p $out/bin/unwrapped

    cp rebar3 $out/bin/unwrapped/rebar3

    makeWrapper \
      $out/bin/unwrapped/rebar3 \
      $out/bin/rebar3 \
      --prefix PATH : ${lib.makeBinPath [
        git
      ]}
  '';

  meta = {
    homepage = "https://github.com/rebar/rebar3";
    description = "Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

    longDescription = ''
      rebar is a self-contained Erlang script, so it's easy to distribute or
      even embed directly in a project. Where possible, rebar uses standard
      Erlang/OTP conventions for project structures, thus minimizing the amount
      of build configuration work. rebar also provides dependency management,
      enabling application writers to easily re-use common libraries from a
      variety of locations (hex.pm, git, hg, and so on).
      '';

    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gleber tazjin ];
    license = lib.licenses.asl20;
  };
}
