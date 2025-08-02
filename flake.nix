{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    quickshell.url = "github:quickshell-mirror/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";

    zaphkiel = {
      url = "github:Rexcrazy804/Zaphkiel?ref=centralization";
      # url = "git+file:///home/rexies/nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
      inputs.systems.follows = "systems";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    zaphkiel,
    ...
  }: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs (import inputs.systems) (
        system: fn (import nixpkgs {inherit system;})
      );
  in {
    packages = forAllSystems (pkgs: {
      default = zaphkiel.packages.${pkgs.system}.kurukurubar-unstable;
    });

    nixosConfigurations.SangoPearl = nixpkgs.lib.nixosSystem {
      modules = [
        zaphkiel.nixosModules.kurukuruDM
        ./configuration.nix
      ];
    };
  };
}
