# This module adds a scripted iPXE entry to the GRUB boot menu.

{ config, lib, pkgs, ... }:

with lib;

let
  pkg = pkgs.os-prober;
  cfg = config.boot.loader.grub.os-prober;
in
{

  ###### interface

  options = {
    boot.loader.grub.os-prober = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable probing for other OSes.
        '';
      };
      dataDir = mkOption {
        type = types.string;
        default = "${pkg.dataDir}";
        description = ''
          Data directory used by os-prober to generate and store partition list etc.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkg ];
    system.activationScripts.os-prober = ''
      install -dm755 ${cfg.dataDir}
    '';
  };
}
