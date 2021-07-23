let 
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in pkgs.mkShell {
  buildInputs = with pkgs; [
    (with dotnetCorePackages; combinePackages [ dotnet-sdk_3 dotnet-sdk_5 ])
    nodejs
    # keep this line if you use bash
    bashInteractive
  ];
}