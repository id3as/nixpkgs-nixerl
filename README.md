# nixpkgs-nixerl

## Table of Contents
1. [Introduction](#introduction)
1. [Status](#status)
1. [Quick Start](#quick-start)
1. [Usage and Versioning](#usage-and-versioning)
1. [Motivation](#motivation)
1. [Credit](#credit)
1. [How It Works](#how-it-works)
1. [FAQ](#faq)
1. [Getting in Touch](#getting-in-touch)

## Introduction

Welcome to the nixpkgs-nixerl repository. This repository is
a Nix Overlay which provides access to Erlang releases from
R18 onwards.

The packages in this overlay are not backed by a binary cache,
so if you choose to use them, Erlang will be compiled from source.

## Status

This overlay is very new, and not yet battle-tested. Feel
free to use it, but there could be breaking changes going forward,
for more information, see the [versioning policy](#usage-and-versioning).

## Quick Start

Overlays can be used multiple ways in a Nix/NixOS environment.

One way is to use `nix-shell`, an example `shell.nix` would be:

```nix
let
  erlangReleases =
    import (builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.0-devel.tar.gz);

  nixpkgs =
    import <nixpkgs> { overlays = [ erlangReleases ]; };

in
  with nixpkgs;
  mkShell {
    buildInputs = with pkgs; [

      # Provide Erlang 22.1.8
      erlang-releases.erlang-22-1-8.erlang

      # Provide Rebar 3.12, built with Erlang 22.1.8
      erlang-releases.erlang-22-1-8.rebar-3-12
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

## Usage and Versioning

This overlay yields the following structure:

```
  <nixpkgs>
  |
  |- pkgs
  |  |
  |  |- erlang-releases                 (a set added by this overlay)
  |  |  |
  |  |  |- <release-number>             (one set per release of Erlang)
  |  |  |  |
  |  |  |  |- erlang                    (a standard build of Erlang, sans Java and ODBC)
  |  |  |  |
  |  |  |  |- rebar-<version-number>    (one derivation per release of rebar3)
  |  |  |  |
```

Both the erlang derivation, and the rebar3 derivations in a release are overridable, so,
for example, to get a release of Erlang which has support for ODBC, one can do:

```nix
let
  erlangReleases =
    import (builtins.fetchTarball https://github.com/nixerl/nixpkgs-nixerl/archive/v1.0.0-devel.tar.gz);

  nixpkgs =
    import <nixpkgs> { overlays = [ erlangReleases ]; };

in
  with nixpkgs;
  mkShell {
    buildInputs = with pkgs; [
      erlang-releases.erlang-22-1-8.erlang.override { withODBC = true; }
    ];
  }
```

This repository is versioned with [semver][semver]; if the attribute structure ever
changes, the major version number will change as well.


## Motivation

So, why does this overlay exist? Erlang is already part of `nixpkgs`, so
what need is there for this?

For me, this fills a particular niche. The Erlang packages available in
`nixpkgs` are of a high quality - and indeed I've used the code from
`nixpkgs` to implement this overlay, however, I frequently finding myself
needing to use a specific version of Erlang.

That is something that can be achieved using nix's override facility,
and I used that approach for a while, this overlay however makes that
far easier by simply providing access to every release of Erlang.

I've also written a quick and dirty utility which can be used to keep
this repository up-to-date easily when new releases of Erlang are
tagged in the OTP GitHub repository. For more information, see
the [How It Works](#how-it-works) section.

## Credit
The building of the underlying derivations for Erlang and Rebar3 is lifted
from the [nixpkgs repository][nixpkgs-gh], and the credit for those goes to the authors
there.

It would be better if I could just use as is, but I wasn't able to find
a nice way to do that from an overlay.

The obvious mechanism would be to call override on existing derivations,
but that makes it (as far as I can tell) to write a portable overlay
because any given version of nixpkgs will have attributes such
as `erlangR18`, `erlangR19`, `erlangR20`, `erlangR21`, and `erlang`,
where `erlang` happens to mean Erlang 22 for a specific release of
nixpkgs.

## How It Works

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


