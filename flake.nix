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

        binaries = {
          "x86_64-linux" = {
            url = "https://github.com/kdcokenny/ocx/releases/download/v${version}/ocx-linux-x64-musl";
            hash = "sha256-2EuwZ72HW8NoT364BnEoIes+/TtvN3UQQN6spzZWRFY=";
          };
          "aarch64-linux" = {
            url = "https://github.com/kdcokenny/ocx/releases/download/v${version}/ocx-linux-arm64-musl";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
          "x86_64-darwin" = {
            url = "https://github.com/kdcokenny/ocx/releases/download/v${version}/ocx-darwin-x64";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
          "aarch64-darwin" = {
            url = "https://github.com/kdcokenny/ocx/releases/download/v${version}/ocx-darwin-arm64";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        };

        bin = binaries.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "ocx";
          inherit version;

          src = pkgs.fetchurl {
            inherit (bin) url hash;
          };

          dontUnpack = true;

          nativeBuildInputs = [ pkgs.patchelf ];

          installPhase = ''
            mkdir -p "$out/bin"
            cp "$src" "$out/bin/ocx"
            chmod +x "$out/bin/ocx"
            patchelf --add-rpath "${pkgs.musl}/lib:${pkgs.stdenv.cc.cc.lib}/lib" "$out/bin/ocx"
          '';

          meta = with pkgs.lib; {
            description = "ShadCN-style CLI for OpenCode extensions";
            homepage = "https://github.com/kdcokenny/ocx";
            license = licenses.mit;
            maintainers = [ ];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bun
            pkgs.nixpkgs-fmt
          ];
        };
      }
    );
}
