{ pkgs, config, lib, ... }:
{
  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;
  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

nixpkgs.overlays = [
  (final: super: {
    makeModulesClosure = x:
      super.makeModulesClosure (x // { allowMissing = true; });
  })
];




boot = {
  kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  #initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
  loader = {
    generic-extlinux-compatible.enable = lib.mkDefault true;
    grub.enable = lib.mkDefault false;
  };
};


  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [ "root" "@wheel" ];
  };

hardware = {
    #raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    raspberry-pi."4".fkms-3d.enable = true;
    #raspberry-pi."4".audio.enable = true;
    #pulseaudio.enable = true;
    enableRedistributableFirmware = true;
};
#sound.enable = true;
console.enable = false;
}
