{ lib, ... }:
let
  profiles = lib.types.enum [ "FA507NU" "QEMU" "default" ];
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