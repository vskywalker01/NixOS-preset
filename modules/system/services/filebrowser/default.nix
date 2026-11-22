{ config, lib, pkgs, inputs, utils, ... }:

let
  format = pkgs.formats.yaml { };
  inherit (lib) types;

  cfg = config.services.filebrowser-quantum;
in
{
  imports = [
    ./proxy.nix
  ];

  options.services.filebrowser-quantum = {
    enable = lib.mkEnableOption "FileBrowser Quantum";

    package = lib.mkPackageOption pkgs "filebrowser-quantum" { };

    user = lib.mkOption {
      type = types.str;
      default = "filebrowser";
      description = "User account under which FileBrowser runs.";
    };

    group = lib.mkOption {
      type = types.str;
      default = "filebrowser";
      description = "Group under which FileBrowser runs.";
    };

    openFirewall = lib.mkEnableOption
      "opening firewall ports for FileBrowser";

    settings = lib.mkOption {
      default = { };

      description = ''
        Settings for FileBrowser.
        Refer to <https://filebrowserquantum.com/en/docs>
        for all supported values.
      '';

      type = types.submodule {
        freeformType = format.type;

        options = {
          http = {
            port = lib.mkOption {
              default = 8085;
              description = "The port to listen on.";
              type = types.port;
            };

            listen = lib.mkOption {
              default = "127.0.0.1";
              description = "The address to listen on.";
              type = types.str;
            };
          };

          server = {
            database.path = lib.mkOption {
              default = "/var/lib/filebrowser-quantum/filebrowser.sqlite";
              description = "Path to FileBrowser's Sqlite database.";
              type = types.str;
            };

            cacheDir = lib.mkOption {
              default = "/var/cache/filebrowser-quantum";
              description = "Directory where FileBrowser stores its cache.";
              type = types.str;
              readOnly = true;
            };

            sources = lib.mkOption {
              default = [
                {
                  path = "/srv/files";
                  config.defaultEnabled = true;
                }
              ];

              description = "List of available file sources.";

              type = types.listOf (types.submodule {
                options = {
                  path = lib.mkOption {
                    type = types.str;
                    description = "Path to the file source.";
                  };

                  config.defaultEnabled = lib.mkOption {
                    default = true;
                    type = types.bool;
                    description = "Whether the source is enabled by default.";
                  };
                };
              });
            };
          };

          auth.adminUsername = lib.mkOption {
            default = "admin";
            description = "The administrator username.";
            type = types.str;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.filebrowser-quantum = {
      after = [ "network.target" ];
      description = "FileBrowser Quantum";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-c"
          (format.generate "config.yaml" cfg.settings)
        ];

        StateDirectory = "filebrowser-quantum";
        CacheDirectory = "filebrowser-quantum";
        Path = [
            pkgs.ffmpeg
        ];
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";

        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;

        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];

        DevicePolicy = "closed";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    users.users = lib.mkIf (cfg.user == "filebrowser") {
      filebrowser = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "filebrowser") {
      filebrowser = { };
    };

    networking.firewall.allowedTCPPorts =
      lib.mkIf cfg.openFirewall [ cfg.settings.http.port ];
  };
}
