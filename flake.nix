{
  description = "Nix flake to install holesail and run executables via npx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages = {
          holesail = pkgs.writeShellScriptBin "holesail" ''
            npx holesail "$@"
          '';

          holesail-manager = pkgs.writeShellScriptBin "holesail-manager" ''
            npx holesail-manager "$@"
          '';

          default = self.packages.${system}.holesail;
        };

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_22
            pkgs.nodePackages.npm
            self.packages.${system}.default
            self.packages.${system}.holesail-manager
          ];
        };
      }
    );
}