{ lib
, config
, modulesPath
, ... }: with lib;

let
  cfg = config.wat.installer.qemu;
in {

  options = {

    wat.installer.qemu.enable = mkEnableOption "Enable qemu installer";

  };

  config = mkIf cfg.enable (mkMerge [
    (import "${modulesPath}/profiles/qemu-guest.nix" { inherit config lib; })
    {

      wat.installer.btrfs = {
        enable = true;
        installDisk = "/dev/vda";
      };

      boot.initrd.availableKernelModules = [
        "ahci"
        "sr_mod"
        "virtio_blk"
        "virtio_pci"
        "xhci_pci"
      ];

      services.qemuGuest.enable = lib.mkDefault true;
    }
  ]);

}
