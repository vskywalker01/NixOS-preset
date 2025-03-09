{
  description = "simple flake for nixos";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager}: {
    nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./modules/hyprland.nix
        ./hardware/qemu.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = import ./home.nix;
        }
      ];
    };
  };
}
