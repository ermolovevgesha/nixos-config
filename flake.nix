{
  description = "My NixOS with Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    ag-unlocker-src.url = "github:confeden/Antigravity";
    ag-unlocker-src.flake = false;  # это не flake, просто исходники
  };

  outputs = { self, nixpkgs, home-manager, noctalia, ag-unlocker-src, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      ag-unlocker-pkg = pkgs.callPackage ./pkgs/ag-unlocker/package.nix {
        src = ag-unlocker-src;
      };
    in {
    # Запустить без установки: nix run /etc/nixos#ag-unlocker
    # Собрать:                 nix build /etc/nixos#ag-unlocker
    packages.${system} = {
      ag-unlocker = ag-unlocker-pkg;
      default = ag-unlocker-pkg;
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.hostPlatform = system; }
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          {
            environment.systemPackages = [ ag-unlocker-pkg ];
          }
        ];
      };
    };
  };
}
