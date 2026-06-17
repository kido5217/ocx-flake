# ocx-flake

Nix flake for [ocx](https://github.com/kdcokenny/ocx) — a ShadCN-style CLI for OpenCode extensions.

## Usage

### Temporary run

```bash
nix run github:kido5217/ocx-flake
```

### Install globally

```bash
nix profile install github:kido5217/ocx-flake
```

### Home-manager

```nix
{
  inputs = {
    ocx-flake.url = "github:kido5217/ocx-flake";
  };

  outputs = { ocx-flake, ... }: {
    homeManagerConfigurations = {
      myuser = { ... }: {
        home.packages = [ ocx-flake.packages.${system}.default ];
      };
    };
  };
}
```
