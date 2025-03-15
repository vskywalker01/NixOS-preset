{
  description = "personal configuration for my NixOS systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  outputs = inputs@{ self, nixpkgs, home-manager, nix-flatpak}: {
    nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        ./hardware/qemu.nix
        ./modules/modules.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = import ./home.nix;
          home-manager.extraSpecialArgs.flake-inputs = inputs;
        }
      ];
    };
  };
}
