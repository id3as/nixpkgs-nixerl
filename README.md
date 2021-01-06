# nixpkgs-nixerl

## Table of Contents
1. [Introduction](#introduction)
1. [Status](#status)
1. [Quick Start](#quick-start)
1. [Usage](#usage)
1. [Versioning](#versioning)
1. [Motivation](#motivation)
1. [Credit](#credit)
1. [FAQ](#faq)
1. [Getting in Touch](#getting-in-touch)

## Introduction

Welcome to the nixpkgs-nixerl repository. This repository is
a Nix Overlay which provides access to Erlang releases from
R18 onwards.

The packages in this overlay are not backed by a binary cache,
so if you choose to use them, Erlang will be compiled from source - the exception
being if you happen to choose the version that is already part of nixpkgs.

### R17 and R23
This overlay also includes experimental support for R17 and R23,
neither of which are currently supported by nixpkgs. In the case of R17, we override the R18
derivation as a basis for the build, and that seems to work. In the case of R23, we override the
R22 derivation as the basis, which again, seems to work. If there are issues with this, we'll
see about doing something different.

## Status

This overlay is built on top of the derivations inside nixpkgs, and as such should
work reasonably well. However, it is not yet battle-tested. Feel
free to use it, but there could be breaking changes going forward - for example, the
attribute structure isn't necessarily nailed down yet.
For more information, see the [versioning policy](#versioning).

One thing I am still working on before I'm happy to declare a stable release
is to support different rebar3 such that one can ask for a specific version
built against a particular version of Erlang.

## Quick Start

Overlays can be used multiple ways in a Nix/NixOS environment.

One way is to use `nix-shell`, an example `shell.nix` would be:

```nix
let
  erlangReleases =
    import (builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.18-devel.tar.gz);

  nixpkgs =
    import <nixpkgs> { overlays = [ erlangReleases ]; };

in
  with nixpkgs;
  mkShell {
    buildInputs = with pkgs; [

      # Provide Erlang 22.2
      nixerl.erlang-22-2.erlang

      # Provide the nixpkgs version of Rebar3 built using Erlang 22.2
      nixerl.erlang-22-2.rebar3
    ];
  }
```

That shell could then be used a number of ways, for example:
1. Running `nix-shell` in the same directory as the `shell.nix` file.
2. Running `nix-shell the-path-to/shell.nix`.
3. Using [`direnv`][direnv] with its built-in [`use nix`][direnv-use-nix] command.

Using `direnv` with Nix feels a lot like magic, I'd highly recommend
trying it out to see if it works for you. If you're using NixOS, turning
it on for `bash`/`zsh` is supported out of the box.

## Usage

This overlay yields the following structure:

```
  <nixpkgs>
  |
  |- pkgs
  |  |
  |  |- nixerl                          (a set added by this overlay)
  |  |  |
  |  |  |- erlang-<release-number>      (one set per release of Erlang)
  |  |  |  |
  |  |  |  |- erlang                    (a standard build of Erlang, sans Java and ODBC)
  |  |  |  |
  |  |  |  |- rebar3                    (the nixpkgs of rebar3, built using the sibling Erlang release)
  |  |  |  |
```

The erlang derivation in a release is overridable, so, for example, to get
a release of Erlang which has support for ODBC, one can do:

```nix
let
  erlangReleases =
    import (builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.18-devel.tar.gz);

  nixpkgs =
    import <nixpkgs> { overlays = [ erlangReleases ]; };

in
  with nixpkgs;
  mkShell {
    buildInputs = with pkgs; [
      (nixerl.erlang-22-2.erlang.override { odbcSupport = true; })
    ];
  }
```

Some of the overridable options are:


| Option               | Default |
| ---------------------|---------|
| enableHipe           | false   |
| enableDebugInfo      | false   |
| enableThreads        | true    |
| enableSmpSupport     | true    |
| enableKernelPoll     | true    |
| javacSupport         | false   |
| odbcSupport          | false   |
| wxSupport            | true    |


## Versioning
This repository is versioned with [semver][semver]; if the attribute structure ever
changes, the major version number will change as well.


## Motivation

So, why does this overlay exist? Erlang is already part of `nixpkgs`, so
what need is there for this?

For me, this fills a particular niche - I frequently finding myself
needing to use a specific version of Erlang.

That is something that can be achieved using nix's override facility,
and I used that approach for a while, this overlay however makes that
far easier by simply providing access to every release of Erlang -
before coming to nix, I used [kerl][kerl] extensively, and wanted something
similar for nix.

I've also written a quick and dirty utility which can be used to keep
this repository up-to-date easily when new releases of Erlang are
tagged in the OTP GitHub repository.

## Credit

The building of the underlying derivation for Erlang is inherited directly from nixpkgs
and the credit for that goes to the authors there.


## FAQ

I've not been asked any questions yet, but if you've got one, feel
free to [get in touch](#getting-in-touch), and I'll update this section as and when.

## Getting in Touch

You can [find me][erlang-slack-channel-profile] lurking in the [Erlang slack channel][erlang-slack-channel] -
if you're not already a member, you can [request to join][erlang-slack-channel-join].




[erlang-slack-channel]: https://erlanger.slack.com/
[erlang-slack-channel-join]: https://bit.ly/ErlangSlack
[erlang-slack-channel-profile]: https://erlanger.slack.com/team/U0ZGJ4H8U
[direnv]: https://direnv.net/
[direnv-use-nix]: https://direnv.net/man/direnv-stdlib.1.html#codeuse-nix-code
[semver]: https://semver.org/
[nixpkgs-gh]: https://github.com/NixOS/nixpkgs
[kerl]: https://github.com/kerl/kerl
