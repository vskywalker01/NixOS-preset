{config, lib, pkgs, ...}:

{
  options.octoprint = {
    enable = lib.mkOption {
      type = lib.types.bool; 
      default = false;
      description = "Enable octoprint";
    };
  };
  config = {
    virtualisation.oci-containers = lib.mkIf (config.octoprint.enable) {
      backend = "docker";
      containers = {
        octoprint = {
          image = "octoprint/octoprint:latest";
          autoStart = true;
          volumes = [
            "octoprint:/octoprint"
          ];
          devices = [
            "/dev/ttyUSB0:/dev/ttyUSB0"
          ];
          extraOptions = [
            "--network=host"
            "--privileged"
          #  "--device-cgroup-rule=c 166:* rmw"
          #  "--device-cgroup-rule=c 188:* rmw"
          #  "--device-cgroup-rule=c 81:* rmw"
          #  "--device-cgroup-rule=c 1:3 rw"
          ];
        };
      };
    };

    networking.firewall = rec {
      allowedTCPPorts = [
        5000
      ];
      allowedUDPPorts = allowedTCPPorts;
    };
    services.udev.extraRules = ''
      SUBSYSTEM!="tty", GOTO="end_octoprint_printers"
      ACTION=="add|change", SUBSYSTEM=="tty", KERNEL=="ttyUSB[0-9]|ttyACM[0-9]", RUN+="${pkgs.docker} exec octoprint rm -rf /dev/3dprinter", RUN+="${pkgs.docker} exec octoprint mknod /dev/3dprinter c %M %m"
      ACTION=="remove", SUBSYSTEM=="tty", KERNEL=="ttyUSB[0-9]|ttyACM[0-9]", RUN+="${pkgs.docker} exec octoprint rm -rf /dev/3dprinter"
      LABEL="end_octoprint_printers"
    '';
  };
  
}