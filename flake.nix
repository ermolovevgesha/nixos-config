{
  description = "My NixOS with Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    antigravity-repo.url = "git+https://github.com/numtide/llm-agents.nix"; 
  };

  outputs = { self, nixpkgs, home-manager, antigravity-repo, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ({ pkgs, ... }: {
            environment.systemPackages = [
              antigravity-repo.packages.${pkgs.system}.antigravity-cli
            ];
          })
        ];
      };
    };
  };
}
