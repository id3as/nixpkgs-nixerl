{ stdenv
, rebar3
, cacert
}:

{ name
, version
, sha256
, src
, meta ? {}
}:

with stdenv.lib;

stdenv.mkDerivation ({
  name = "rebar-deps-${name}-${version}";

  phases = [ "downloadPhase" "installPhase" ];

  downloadPhase = ''
    cp ${src} .
    HOME='.' \
      DEBUG=1 \
      GIT_SSL_CAINFO=${cacert}/etc/ssl/certs/ca-bundle.crt \
      SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt \
      ${rebar3}/bin/rebar3 get-deps

    # git directories can change from one download to another, so
    # get rid of them now we've got what we needed
    find -name .git -type d | xargs rm -rf
  '';

  installPhase = ''
    mkdir -p "$out/_checkouts"

    for i in ./_build/default/lib/* ; do
       echo "$i"
       cp -R "$i" "$out/_checkouts"
    done
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  inherit meta;
})

