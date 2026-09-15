{
  description = "furuochen macOS: nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      username = "furuochen";
      darwinSystem = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self username; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs = { inherit inputs username; };
            home-manager.users.${username} = import ./nix/home.nix;
          }
        ];
      };
    in
    {
      # Stable name for new machines: darwin-rebuild switch --flake ~/.config#laptop
      darwinConfigurations.laptop = darwinSystem;
      # Current hostname, so `darwin-rebuild switch --flake ~/.config` also works here.
      darwinConfigurations."Rays-Laptop" = darwinSystem;
    };
}
