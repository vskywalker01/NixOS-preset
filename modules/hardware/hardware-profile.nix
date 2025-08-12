{ lib, ... }:
let
  profiles = lib.types.enum [ "FA507NU" "QEMU" "default" "R3" "RPI3" "I3"];
in
{
  options.hardware = {
    hardware-profile = lib.mkOption {
      type = profiles;
      default = "default";
      description = "Hardware configuration selection";
    };
  };
}