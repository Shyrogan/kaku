{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    # load modules on boot
    kernelModules = ["acpi_call" "amdgpu"];
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = ["amd_pstate=active" "amd_iommu=on" "nvme_core.default_ps_max_latency_us=0"];
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  networking.hostName = "aesthetic";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;
    # steam.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    # for SSD/NVME
    fstrim.enable = true;
  };
}
