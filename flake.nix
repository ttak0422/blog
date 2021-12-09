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
      inherit (flake-utils.lib) eachDefaultSystem eachSystem allSystems;
      # WIP......
      stack = fetchTarball {
        url =
          "https://github.com/CaiJimmy/hugo-theme-stack/archive/refs/heads/master.tar.gz";
        sha256 = "12r53vmnfjv8140qnw7a3qhi0xy2lff3acfadliksv5kkjhm9kqi";
      };
    in eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) mkShell runCommand callPackage;
      in {
        devShell = mkShell {
          buildInputs = with pkgs; [ hugo nixfmt pre-commit ];
          shellHook = ''
            STACK=themes/hugo-theme-stack
            mkdir -p themes
            ln -snf ${stack} $STACK
          '';
        };
      });
}
