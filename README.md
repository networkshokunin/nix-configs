<div align="center">
<h1>
<img width="100" src="docs/nixos-ascendancy.png" /> <br>
</h1>
</div>

# EmergentMind's Nix-Config Starter

This is a stripped-down, reference version of EmergentMinds's [nix-config](https://github.com/EmergentMind/nix-config) intended to help you set up your own without having to delete all of the personal configurations I use that you may not want.

This repository makes several assumptions as described in the contents below.

Note that my actual nix-config has already deviated from this repository and will continue to do so over time. Depending on how much use this starter repo gets, I may try to keep it updated but there are no guarantees. Please feel free to let me know if you notice any issues or discrepancies. Contributions are welcome.

## Table of Contents

- [How To Use](#how-to-use)
- [Secrets Management](#secrets-management)
- [Installation Steps](#installation-steps)
- [Guidance and Resources](#guidance-and-resources)
- [Support This Project](#support-this-project)
- [Acknowledgements](#acknowledgements)

---

## Requirements

- NixOS 25.05 or later
- flakes must be enabled
- a clone of this repository that you will configure according to your needs (instructions below)
- a clone of my `nix-secrets-reference` repository (simple branch) that you will configure according to you needs (instructions below)

NOTE: You may have noticed that this repo includes a directory called `nixos-installer`. The installer included there is oriented towards installing NixOS and nix-config on a remote host _from_ a machine already running NixOS and the nix-config. While it can technically be used otherwise, I don't recommend doing so for new users. If you are installing to a remote target, and are already comfortable with nix configuration, you can use it at your own discretion. Information on how it works is referenced below in the [Installation on Remote Targets](#installation-on-remote-targets) section below.

## How To Use

Your being here likely means that you are relatively new to Nix and NixOS, or perhaps you are just looking to improve your config. That's great, welcome!

Regardless of your skill level, I recommend that you start small, get a minimal variant of your needs working first and then iterate the configuration from there. As mentioned, this is a stripped-down skeleton of a configuration so it doesn't include enablement of a window manager and other applications that you while likely want.

1. Read through this entire README before actually starting. It's always better to know where you're going and roughly what road you'll be taking before you start!
2. Install the latest, stable version of NixOS on your machine if you haven't already. You can find installation files one the official NixOS website at [https://nixos.org/download/](https://nixos.org/download/). Make sure you download the installer for "NixOS: the Linux distribution" and not "Nix: the package manager".
   For new users, I recommend using the Graphical ISO image because it simplifies the process.
3. Take some time to get familiar with the OS and and how configuration works.
4. Clone this repo to your local machine and ensure that it is renamed from `nix-config-starter` to `nix-config`
5. This repo includes a .envrc that loads packages defined by the flake's shell.nix file when you are in the directory. The first time you enter the directory in your terminal, you should see an error that states:
   `direnv: error /home/foo/nix-config/.envr is blocked. Run 'direnv allow' to approve its content`
6. Running `direnv allow` will load several packages that are required to simplify building and switching to the config.
7. Familiarize yourself with both the structure and contents of the repo.
8. Throughout the repos are several `#FIXME(starter)` comments specifically intended to bring your attention to areas that must be edited to suit your needs.

   Work your way through the repo contents and adjust the contents according to the comments you find.
9. Secrets for your config will be stored in a separate repository called `nix-secrets` that is pulled in as a flake input and managed using the sops-nix tool. Details on how nix-config handles secrets are covered an article and video available at [https://unmovedcentre.com/posts/secrets-management/](https://unmovedcentre.com/posts/secrets-management/).

   Clone my [nix-secrets-reference](https://github.com/EmergentMind/nix-secrets-reference) repository and ensure that it is renamed from `nix-secrets-reference` to `nix-secrets`.

   `nix-config-starter` assumes that you will be using the `simple` branch of `nix-secrets-reference`.

   IMPORTANT: For simiplicity, the scripts in `nix-config` assume that your `nix-secrets` repo will be in the same parent directory as `nix-config`.

    For example:
    ```
    ~/src/nix-config
    ~/src/nix-secrets
    ```
10. Set up your secrets repository according to your needs. Again, start small!
    For details on how this is accomplished, how to approach different scenarios, and troubleshooting for some common hurdles, please see my article and accompanying YouTube video [NixOS Secrets Management](https://unmovedcentre.com/posts/secrets-management/) available on my website.
11. Make sure to push your nix-secrets changes ;)
12. Build your nix-config. You can perform the build and switch into it by running `just rebuild`.
13. If you encounter errors or issues during build, take your time to correct them and try again.
    Nix build errors are notoriously cryptic. Don't despair; the way out is through.
14. Ask for help by either creating an issue at [https://github.com/EmergentMind/nix-config-starter/issues](https://github.com/EmergentMind/nix-config-starter/issues) or stop by our [Discord server](https://discord.gg/XTFg57xGxC).

REMINDER: Start small and take your time configuring the packages and services you want as you go. Small, incremental changes are easier to fix when something goes wrong.

## I've got my nix-config build and running, what's next?

After you've set up your variation of nix-config yourself and taken some time to declare the packages and options you want for them, you may want to enable useful features like a windows manager, Yubikeys, LUKS encryption, themes/rice, etc. Below you will find some references that show where to find more information about various features. The list isn't exhaustive and I can't guarantee you'll find what you're looking for but I hope that it at least points you in the direction to find what you want.

### Where to find how I implemented various features and tools:
- Windows manager
    - Very simple XFCE implementation:
        - https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/optional/xfce.nix
    - Hyprland implementation:

        Hosts-level files
        - https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/optional/hyprland.nix
        - https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/optional/wayland.nix

        Home-level files
        - https://github.com/EmergentMind/nix-config/tree/dev/home/common/optional/desktops
- Themes and Styling
    - [Stylix](https://github.com/nix-community/stylix) is the fastest way to get host or user-wide styling
    - https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/optional/stylix.nix
- Adding Yubikeys
    - See my article and video on how to set up Yubikeys [https://unmovedcentre.com/posts/improving-qol-on-nixos-with-yubikey/](https://unmovedcentre.com/posts/improving-qol-on-nixos-with-yubikey/)
- LUKS encryption
    - Much of what is required to use LUKS the way I do (via Disko) is documentation on the disko
    - Live examples of my disko specifications can be found in the following files:
      - https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/disks/btrfs-luks-impermanence-disk.nix
      - https://github.com/EmergentMind/nix-config/blob/dev/hosts/common/disks/ghost.nix
    - I also cover LUKS set up in the following article and video, however they are oriented towards using the `nixos-installer`, which has changed quite a bit since the article and video were published: https://unmovedcentre.com/posts/remote-install-nixos-config/

If there are any specific references you are looking for or that you think should be included here, please do let me know! I can only guess at how you will interpret what I've provided here and providing feedback is critical for ensuring that you and others like you have as smooth a journey as possible.

## Guidance and Resources

- Watch NixOS related videos on my [YouTube channel](https://www.youtube.com/@Emergent_Mind).
- Chat with me directly on our [Discord server](https://discord.gg/XTFg57xGxC).

- [NixOS.org Manuals](https://nixos.org/learn/)
- [Official Nix Documentation](https://nix.dev)
  - [Best practices](https://nix.dev/guides/best-practices)
- [Noogle](https://noogle.dev/) - Nix API reference documentation.
- [Official NixOS Wiki](https://wiki.nixos.org/)
- [NixOS Package Search](https://search.nixos.org/packages)
- [NixOS Options Search](https://search.nixos.org/options?)
- [Home Manager Option Search](https://home-manager-options.extranix.com/)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/) - an excellent introductory book by Ryan Yin

## Installation on Remote Targets

For details on how to use the nixos-installer directory and `scripts/bootstrap-nixos.sh` script, please see my article and accompanying YouTube video [Remotely Installing NixOS and nix-config with Secrets](https://unmovedcentre.com/posts/remote-install-nixos-config/).


## Support This Project

Sincere thanks to all of my generous supporters!

If you find what I do helpful, please consider supporting my work using one of the links under "Sponsor this project" on the right-hand column of this page.

I intentionally keep all of my content ad-free but some platforms, such as YouTube, put ads on my videos outside of my control.

## Acknowledgements
n
Those who have heavily influenced this strange journey into the unknown.

- [FidgetingBits](https://github.com/fidgetingbits) - You told me there was a strange door that could be opened. I'm truly grateful.
- [Mic92](https://github.com/Mic92) and [Lassulus](https://github.com/Lassulus) - My nix-config leverages many of the fantastic tools that these two people maintain, such as sops-nix, disko, and nixos-anywhere.
- [Misterio77](https://github.com/Misterio77) - Structure and reference.
- [Ryan Yin](https://github.com/ryan4yin/nix-config) - A treasure trove of useful documentation and ideas.
- [VimJoyer](https://github.com/vimjoyer) - Excellent videos on the high-level concepts required to navigate NixOS.

---

[Return to top](#emergentminds-nix-config-starter)
