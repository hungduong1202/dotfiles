# Hostname is read from config.nix
HOSTNAME := $(shell nix eval --raw --file config.nix hostname 2>/dev/null || echo "HUNGDUONG-MAC")
NIX_FLAGS := --extra-experimental-features 'nix-command flakes'

.PHONY: build check fmt dry-run test deploy switch clean

# ─── Test Commands (no sudo needed) ───────────────────────────────

## Build the system derivation without applying
build:
	nix build .\#darwinConfigurations.$(HOSTNAME).system $(NIX_FLAGS)

## Validate flake structure and evaluate all outputs
check:
	nix flake check $(NIX_FLAGS)

## Format all nix files with alejandra
fmt:
	nix fmt . $(NIX_FLAGS)

## Show what would change without applying (requires build first)
dry-run: build
	./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME) --dry-run 2>&1 || true

## Run all tests: fmt check + build + dry-run
test: fmt check build dry-run
	@echo ""
	@echo "✅ All tests passed! Run 'make deploy' to apply."

# ─── Deploy Commands (requires sudo) ─────────────────────────────

## Build and apply the configuration (TouchID → build → apply)
deploy: build
	sudo -v
	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME)

## Apply without rebuilding (use after 'make build')
switch:
	sudo -v
	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#$(HOSTNAME)

# ─── Utilities ────────────────────────────────────────────────────

## Remove build artifacts
clean:
	rm -f result

## Show available commands
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Test (no sudo):"
	@echo "  build     Build system derivation"
	@echo "  check     Validate flake outputs"
	@echo "  fmt       Format nix files (alejandra)"
	@echo "  dry-run   Show what would change"
	@echo "  test      Run all tests (fmt + check + build + dry-run)"
	@echo ""
	@echo "Deploy (sudo):"
	@echo "  deploy    Build and apply config"
	@echo "  switch    Apply without rebuild"
	@echo ""
	@echo "Utilities:"
	@echo "  clean     Remove build artifacts"
	@echo "  help      Show this help"
