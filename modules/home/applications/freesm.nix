{config, lib, pkgs, flake-inputs, systemConfig ? {}, ...}:
{
    config = lib.mkIf(systemConfig.applications.gaming.enable){
        services.flatpak.remotes = [
            {
                name = "freesmlauncher";
                location = "https://flatpak.freesmlauncher.org/freesmlauncher.flatpakrepo";
            }
        ];

        services.flatpak.packages = [
            "org.freesmlauncher.FreesmLauncher"
        ];

    };
}
