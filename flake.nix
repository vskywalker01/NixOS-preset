{
    description = "personal configuration for my NixOS systems";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak";
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
        nvf = {
            url = "github:NotAShelf/nvf";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        silentSDDM = {
            url = "github:uiriansan/SilentSDDM";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        lanzaboote = {
            url = "github:nix-community/lanzaboote/v1.0.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    nixConfig = {
        extra-substituters = [
            "https://nix-community.cachix.org"
            "https://cache.nixos-cuda.org"
            "https://cache.nixos.org/" 
        ];
        extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="    
        ];
    };
    outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-hardware,cachix,nix-minecraft,nvf,silentSDDM, lanzaboote}: {
        nixosConfigurations.skywalker-pi3 = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "aarch64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.raspberry.RPI3.enable=true;
                    services.openssh.enable=true;
                    services.flatpak.enable=false;
                    #virtualisation.docker.enable=true;
          
                    services.octoprint = {
                        enable=true;
                        proxy.enable = true;
                        webcam.enable = true;
                        webcam.resolution = "1280x720";
                    };
                    services.filebrowser = {
                        enable=true;
                        proxy = {
                            enable = true;
                        };
                        settings = {
                            root = "/srv/hdd";
                            port = 8334;
                        };
                    };
                    services.open-webui.proxy = {
                        enable = true; 
                        server = "192.168.1.250";
                        server-mac = "40:B0:76:D9:79:E1";
                        enableWol = true; 
                    };
                    services.minecraft-server.proxy = {
                        enable = true; 
                        server = "192.168.1.250";
                        server-mac = "40:B0:76:D9:79:E1";
                        enableWol = true;
                    };
                    networking.firewall.allowedTCPPorts = [80 443 53 25565];
                    networking.firewall.allowedUDPPorts = [53];

                    networking = {
                        interfaces.eth0 = {
                            useDHCP = false;
                            ipv4.addresses = [{
                                address = "192.168.1.254";
                                prefixLength = 24;
                            }];

                            wakeOnLan.enable = true;
                        };
                        defaultGateway = "192.168.1.1";
                    };

                    systemd.tmpfiles.rules = [
                        "d /srv/hdd 0755 root root -"
                    ];

                    fileSystems."/srv/hdd" = {
                        device = "/dev/sda1";
                        fsType = "btrfs";
                        options = [
                            "defaults" 
                            "compress=zstd"
                        ];
                    };

                    services.dnsmasq = {
                        enable = true;
                        settings = {
                            address = [
                                "/skywalker.home/192.168.1.254"
                            ];

                            server = [
                                "192.168.1.1"
                                "8.8.8.8"
                            ];
                        };
                    };

                    services.tailscale = {
                        enable = true;
                        useRoutingFeatures = "server";
                        extraUpFlags = [
                            "--advertise-routes=192.168.1.254/32"
                        ];
                    };

                })
            ];
        };
        nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.virtual.qemu.enable=true;
                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    programs.hyprland.enable=true;
                    

                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applicaitons.developing.enable = true;
            
                })
            ];
        };
        nixosConfigurations.skywalker-tuf = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.asus.FA507NU.enable=true;

                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    virtualisation.virtualbox.host.enable=true;
                    virtualisation.libvirtd.enable=true;
    
                    applications.ai.enable = true;
                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applications.gaming.enable = true; 
                    applications.cads.enable = true; 
                    applications.video-editing.enable = true; 
                    applications.developing.enable = true;

                    services.samba.enable = true;

                    services.displayManager.autoLogin = {
                        enable = true;
                        user = "vittorio";
                    };
                    
                })
            ];
        };
        nixosConfigurations.skywalker-r5 = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.asus.A320M-K.enable=true;

                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    virtualisation.virtualbox.host.enable=true;

                    virtualisation.libvirtd.enable=true;
                    services.minecraft-servers = {
                        enable = true;
                        #dataDir = "/srv/hddraid/minecraft";
                        servers.default = {
                            enable = true;
                            serverProperties = {
                                port = 25565;
                                "rcon.password" = "supersecret-password";
                                "rcon.port" = 25575;
                            };
                        };
                    };
                    networking.firewall.allowedTCPPorts = [ 
                        25565
                    ];


                    services.open-webui.openFirewall = true;
                    applications.ai.enable = true;

                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applications.gaming.enable = true; 
                    applications.cads.enable = true; 
                    applications.video-editing.enable = true; 
                    applications.developing.enable = true;                    
                    services.displayManager.autoLogin = {
                        enable = true;
                        user = "vittorio";
                    }; 
                    networking = {
                        interfaces.eth0 = {
                            useDHCP = false;
                            ipv4.addresses = [{
                                address = "192.168.1.250";
                                prefixLength = 24;
                            }];

                            wakeOnLan.enable = true;
                        };
                        defaultGateway = "192.168.1.1";
                        nameservers = [ "192.168.1.254" "192.168.1.1"];
                    };
                    fileSystems."/srv/hddraid" = {
                        device = "/dev/disk/by-uuid/a4a8fac9-9bbd-47b6-b984-0668f4ae4244";
                        fsType = "btrfs";
                        options = [
                            "defaults" 
                            "compress=zstd"
                        ];
                    };
                    systemd.tmpfiles.rules = [
                        "d /srv/hddraid 0777 root root -"
                    ];
                })
            ];
        };
        nixosConfigurations.skywalker-i3 = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            system = "x86_64-linux";
            modules = [ 
                ./modules
                ./configuration.nix

                ({config,lib,...}:
                    {
                    hardware.toshiba.I3.enable=true;

                    services.openssh.enable=true;
                    virtualisation.docker.enable=true;
                    virtualisation.virtualbox.host.enable=false;
                    virtualisation.libvirtd.enable=false;
    
                    services.ollama.enable = false;

                    programs.hyprland.enable=true;
 
                    applications.tools.enable = true;
                    applications.office.enable = true;
                    applications.gaming.enable = false; 
                    applications.cads.enable = true; 
                    applications.video-editing.enable = false; 
                    applications.developing.enable = true; 
                    
                })
            ];
        };
    };
}
