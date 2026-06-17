# AGENTS.md

## Project Overview

Nix flake that packages [ocx](https://github.com/kdcokenny/ocx) — a ShadCN-style CLI for OpenCode extensions. Fetches the pre-built npm tarball and wraps it with bun runtime.

## Build & Test

```bash
nix build .#          # build the package
nix run .# -- --help   # test the binary
nix flake check        # run all checks
```

## Update to a new version

1. Check latest npm version: `npm view ocx version`
2. Update `version` in `flake.nix`
3. Update `hash` in `fetchurl`:
   - Run `nix-prefetch-url "https://registry.npmjs.org/ocx/-/ocx-<version>.tgz"`
   - Convert to SRI: `nix hash convert --from base32 --to sri "sha256:<hash>"`
4. `nix build .#` to verify

## Code style

- Format: `nixpkgs-fmt flake.nix`
- Keep `flake.nix` self-contained, no overlays or modules
- All systems handled via `flake-utils.lib.eachDefaultSystem`
