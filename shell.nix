let 
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [ 
      (import ./nix/dotnet-sdk.nix) 
    ]; 
  };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    dotnet-sdk
    nodejs
    # keep this line if you use bash
    bashInteractive
  ];
}