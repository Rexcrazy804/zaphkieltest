{
  description = "A very cute flake >w<";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-impure = {
      # url = "git+file:///home/rexies/Everwinter/nix/hjem-impure";
      url = "github:Rexcrazy804/hjem-impure";
    };
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";

    zaphkiel = {
      url = "github:Rexcrazy804/Zaphkiel";
      # url = "git+file:///home/rexies/nixos"; # here for testing ONLY
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
      inputs.systems.follows = "systems";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    zaphkiel,
    hjem,
    ...
  }: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs (import inputs.systems) (
        system: fn (import nixpkgs {inherit system;})
      );
  in {
    packages = forAllSystems (pkgs: {
      default = zaphkiel.packages.${pkgs.system}.kurukurubar-unstable;
      testVm = self.nixosConfigurations.SangoPearl.config.system.build.vm;
    });

    nixosConfigurations.SangoPearl = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        zaphkiel.nixosModules.kurukuruDM
        hjem.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
