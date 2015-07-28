# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  configDir = /etc/nixos;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Shadow"; # Define your hostname.
  networking.hostId = "7d47a758";
  networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "es";
    defaultLocale = "es_ES.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = let
    basePkgs    = import "${configDir}/packages/base.nix" pkgs;
    desktopPkgs = import "${configDir}/packages/awesome.nix" pkgs;
    devPkgs     = import "${configDir}/packages/dev.nix" pkgs;
    multimediaPkgs    = import "${configDir}/packages/multimedia.nix" pkgs;
  in basePkgs ++ desktopPkgs ++ devPkgs ++ multimediaPkgs;

  services.xserver.enable=true;
  services.xserver.layout = "es";
  services.xserver.synaptics.enable=true;
  services.xserver.synaptics.horizontalScroll=true;
  services.xserver.synaptics.twoFingerScroll=true;
  services.xserver.displayManager.slim.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  security.sudo.configFile="
    root ALL=(ALL) ALL
    sisekeom ALL=(ALL) ALL

  ";

  users.extraUsers.sisekeom = {
    isNormalUser = true;
    uid = 1001;
    shell="/run/current-system/sw/bin/zsh";
  };

}
