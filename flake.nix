{
  description = "tech blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      inherit (builtins) fetchTarball;
      inherit (flake-utils.lib) eachDefaultSystem mkApp;
    in eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) mkShell runCommand callPackage;
        blog = callPackage ./nix/blog { };
      in rec {
        devShell = mkShell {
          buildInputs = with pkgs; [ hugo nixfmt pre-commit ];
          shellHook = ''
            ${blog.shellHook}
          '';
        };
        defaultPackage = blog.blogDrv;
      });
}
