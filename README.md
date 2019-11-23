# nixpkgs-nixerl

## Introduction

Welcome to the nixpkgs-nixerl repository. This repository is
a Nix Overlay which provides access to Erlang releases from
R18 onwards.

The packages in this overlay are not backed by a binary cache,
so if you choose to use them, Erlang will be compiled from source.

## Quick Start

Overlays can be used multiple ways in a Nix/NixOS environment.

One way is to use `nix-shell`, an example `shell.nix` would be:

```nix
insert example here
```

That shell could then be used a number of ways, for example:
1. Running `nix-shell` in the same directory as the `shell.nix` file.
2. Running `nix-shell the-path-to/shell.nix`.
3. Using [`direnv`][direnv] with it's built-in `use_nix` command.

Using `direnv` with Nix feels a lot like magic, I'd highly recommend
trying it out to see if it works for you. If you're using NixOS, turning
it on for `bash`/`zsh` is supported out of the box.

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


## How It Works

## FAQ

I've not been asked any questions yet, but if you've got one, feel
free to [get in touch](#getting-in-touch), and I'll update this section as and when.

## Getting in Touch

You can [find me][erlang-slack-channel-profile] lurking in the [Erlang slack channel][erlang-slack-channel] -
if you're not already a member, you can [request to join][erlang-slack-channel-join].




[erlang-slack-channel] https://erlanger.slack.com/
[erlang-slack-channel-join] https://bit.ly/ErlangSlack
[erlang-slack-channel-profile] https://erlanger.slack.com/team/U0ZGJ4H8U
[direnv] https://direnv.net/

