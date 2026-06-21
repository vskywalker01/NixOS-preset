{ config, lib, pkgs, ... }:

let
    pname = "StabilityMatrix"; 
    version = "2.15.8";

    src = pkgs.fetchzip {
        url = "https://github.com/LykosAI/StabilityMatrix/releases/download/v${version}/${pname}-linux-x64.zip";
        hash = "sha256-K5DgPeQl9GpNAMf9no7v2vqxWdCP3WaadebaAM82DJw=";
    };
    appimageContents = pkgs.appimageTools.extractType2 {
        inherit pname version;
        src = "${src}/${pname}.AppImage";
    };
    StabilityMatrix = pkgs.appimageTools.wrapType2 {
        inherit pname version;

        src = "${src}/${pname}.AppImage";

        extraPkgs = pkgs: with pkgs; [
            zlib
            fuse
            icu
            libxcrypt-legacy
            python312
            libepoxy
            zstd
            gcc
        ];
        extraInstallCommands = ''
            install -Dm444 \
            ${appimageContents}/zone.lykos.stabilitymatrix.desktop \
            $out/share/applications/stabilitymatrix.desktop

            install -Dm444 \
            ${appimageContents}/zone.lykos.stabilitymatrix.png \
            $out/share/pixmaps/stabilitymatrix.png

            substituteInPlace \
            $out/share/applications/stabilitymatrix.desktop \
            --replace-fail "Exec=/usr/bin/StabilityMatrix.Avalonia" "Exec=StabilityMatrix" \
            --replace "TryExec=/usr/bin/StabilityMatrix.Avalonia" "" \
            --replace-fail "Icon=zone.lykos.stabilitymatrix" "Icon=stabilitymatrix"
        '';  
    };

in
    {
    config = lib.mkIf (config.applications.ai.enable) {
        environment.systemPackages = [
            StabilityMatrix
        ];
    };
}
