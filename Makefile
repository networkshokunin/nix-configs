HOSTNAME := $(strip $(shell uname -n))
############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################

# Run eval tests
test:
	nix eval .#evalTests --show-trace --print-build-logs --verbose

# update all the flake inputs
up:
	nix flake update

# List all generations of the system profile
history:
	nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
repl:
  	repl -f flake:nixpkgs

# remove all generations older than 7 days
clean:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
gc:
  # garbage collect all unused nix store entries
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old

build:
	sudo nixos-rebuild switch --flake ".#${HOSTNAME}"