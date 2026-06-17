{
  description = "ocx - OpenCode extension manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        version = "2.0.11";

        npm-tarball = pkgs.fetchurl {
          url = "https://registry.npmjs.org/ocx/-/ocx-${version}.tgz";
          hash = "sha256-Pw9ka7wX7WMaSzKRrXClbiHwebxZRiy0Z2wmLF+Jfj8=";
        };
      in
      {
        packages.default = pkgs.runCommand "ocx-${version}"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            buildInputs = [ pkgs.bun ];
            meta = with pkgs.lib; {
              description = "ShadCN-style CLI for OpenCode extensions";
              homepage = "https://github.com/kdcokenny/ocx";
              license = licenses.mit;
              maintainers = [ ];
            };
          }
          ''
            tar -xzf "${npm-tarball}"
            mkdir -p "$out/bin"
            cp package/dist/index.js "$out/bin/ocx"
            chmod +x "$out/bin/ocx"
            wrapProgram "$out/bin/ocx" \
              --set PATH "${pkgs.bun}/bin" \
              --prefix PATH : "${pkgs.bun}/bin"
          '';

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bun
            pkgs.nixpkgs-fmt
          ];
        };
      }
    );
}
