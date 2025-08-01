# built with nix build .#nixosConfigurations.SangoPearl.config.system.build.vm
# you are welcome :>
{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [(modulesPath + "/virtualisation/qemu-vm.nix")];

  networking.hostName = "SangoPearl";
  system.stateVersion = "25.05";
  virtualisation = {
    diskSize = 4 * 1024;
    memorySize = 2 * 1024;
    cores = 2;
  };

  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.rexies = {
    enable = true;
    initialPassword = "kokomi";
    createHome = true;
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [];
  };

  programs.hyprland.enable = true;
  programs.kurukuruDM = {
    enable = true;
    package = pkgs.kurukurubar;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
