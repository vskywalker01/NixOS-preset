{ config, pkgs, lib, inputs, ... }: 
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  config = lib.mkIf (config.hardware.hardware-profile == "R3") {
    environment.systemPackages = with pkgs; [ lact ];
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      boot = lib.mkMerge [
      (lib.mkIf
        (
          (lib.versionAtLeast kver "5.17")
          && (lib.versionOlder kver "6.1")
        )
        {
          kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
          kernelModules = [ "amd-pstate" ];
        })
      (lib.mkIf
        (
          (lib.versionAtLeast kver "6.1")
          && (lib.versionOlder kver "6.3")
        )
        {
          kernelParams = [ "amd_pstate=passive" ];
        })
      (lib.mkIf (lib.versionAtLeast kver "6.3") {
        kernelParams = [ "amd_pstate=active" ];
      })
    ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    fileSystems."/run/media/hddraid" = {
      device = "/dev/disk/by-uuid/a4a8fac9-9bbd-47b6-b984-0668f4ae4244";
      fsType = "btrfs";
      options = [
        "defaults" 
        "compress=zstd"
      ];
    };

  };  
}