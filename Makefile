OSFLAG 				:=
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
	    OSFLAG = LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
	    OSFLAG = DARWIN
	endif

all:
	@echo $(OSFLAG)

#HOSTNAME := $(strip $(shell uname -n))
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
	@if [ "$(OSFLAG)" = "LINUX" ]; then \
		HOSTNAME := $(strip $(shell uname -n)) \
		sudo nixos-rebuild switch --flake ".#${HOSTNAME}"; \
	fi

	@if [ "$(OSFLAG)" = "DARWIN" ]; then \
		HOSTNAME := $(shell uname -n) \
		nix build .#darwinConfigurations.${HOSTNAME}.system \
		--extra-experimental-features 'nix-command flakes'; \
		./result/sw/bin/darwin-rebuild switch --flake .#${HOSTNAME}; \
	fi	

osx:
	nix build .#darwinConfigurations.david-mbp14.system \
	   --extra-experimental-features 'nix-command flakes'

	./result/sw/bin/darwin-rebuild switch --flake .#david-mbp14
