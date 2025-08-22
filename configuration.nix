# built with nix build .#nixosConfigurations.SangoPearl.config.system.build.vm
# you are welcome :>
{
  lib,
  config,
  modulesPath,
  inputs,
  pkgs,
  ...
}: {
  # only required for the VM
  imports = [(modulesPath + "/virtualisation/qemu-vm.nix")];

  # this is what you need
  programs.hyprland.enable = true;
  programs.kurukuruDM = {
    enable = true;
    package = pkgs.kurukurubar;
    settings.wallpaper = inputs.zaphkiel.packages.${pkgs.system}.booru-images.i2768802;
  };

  environment.systemPackages = [
    # the kurukuruDM module adds an overlay including pkgs.kurukurubar and pkgs.kurukurubar-unstable
    pkgs.kurukurubar

    # if not using the kurukuruDM nixosModule
    # inputs.zaphkiel.packages.${pkgs.systme}.kurukurubar
  ];
  hjem.extraModules = [inputs.hjem-impure.hjemModules.default];
  hjem.users.rexies = {
    enable = true;
    user = "rexies";
    impure = {
      enable = true;
      dotsDir = "${./mytestdots}";
      dotsDirImpure = "/home/rexies/mytestdots";
    };
    directory = config.users.users.rexies.home;
    clobberFiles = lib.mkForce true;
    files = {
      ".config/hypr/hyprland.conf".text = ''
        exec-once = kurukurubar
        misc {
          force_default_wallpaper = 1
          disable_hyprland_logo = true
        }
      '';
      ".config/background".source = config.programs.kurukuruDM.settings.wallpaper;
    };
    xdg.config.files = let
      inherit (config.hjem.users.rexies.impure) dotsDir;
    in {
      "sangonomiya".source = dotsDir + "/kokomi";
    };
  };

  # the simp
  users.users.rexies = {
    enable = true;
    initialPassword = "kokomi";
    createHome = true;
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [pkgs.yazi];
  };

  # vm only stuff
  virtualisation = {
    diskSize = 4 * 1024;
    memorySize = 2 * 1024;
    cores = 2;
  };

  # just makes my debugging life easier
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "SangoPearl";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";
}
