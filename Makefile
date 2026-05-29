# please change 'hostname' to your hostname

HOSTNAME := HUNGDUONG-MAC
deploy:
	nix build .#darwinConfigurations.$(HOSTNAME).system \
	   --extra-experimental-features 'nix-command flakes'

	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME)

switch:
	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME)
