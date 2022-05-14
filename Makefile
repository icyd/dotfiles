user ?= beto
host ?= .\#
standalone-channel ?= master
all: hm nixos

nixos:
	sudo nixos-rebuild switch --flake $(host)

nixos-build:
	nixos-rebuild build --flake $(host)

hm: hm-build
	./result/activate

hm-build:
	nix build .#homeManagerConfigurations.$(user).activationPackage

hm-standalone-install:
	nix-channel --add https://github.com/nix-community/home-manager/archive/$(standalone-channel).tar.gz home-manager
	nix-channel --update
	export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
	nix-shell '<home-manager>' -A install

.SILENT:
clean:
	rm -rf result

.PHONY: clean all nixos nixos-build hm hm-pkg
