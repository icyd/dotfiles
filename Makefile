user ?= $(shell whoami)
host ?= .\#
standalone-channel ?= master
uname_s := $(shell uname -s)
uname_m := $(shell uname -m)
all: hm nixos

nixos:
ifeq ($(uname_s), Darwin)
	darwin-rebuild switch --flake $(host)
else
	nixos-rebuild switch --flake $(host) --use-remote-sudo
endif

nixos-build:
ifeq ($(uname_s), Darwin)
	darwin-rebuild build --flake $(host)
else
	nixos-rebuild build --flake $(host)
endif

hm: hm-build
	./result/activate

hm-build:
	nix build .#homeConfigurations.\"$(user)\".activationPackage

hm-standalone-install:
	nix-channel --add https://github.com/nix-community/home-manager/archive/$(standalone-channel).tar.gz home-manager
	nix-channel --update
	export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
	nix-shell '<home-manager>' -A install

.SILENT:
clean:
	rm -rf result

.PHONY: clean all nixos nixos-build hm hm-pkg
