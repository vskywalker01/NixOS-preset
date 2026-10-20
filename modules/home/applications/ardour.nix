{config, lib, pkgs,flake-inputs, systemConfig ? {} ,...}:
let
  makePluginPath = format: 
    "$HOME/.${format}:" + 
    (lib.makeSearchPath format [ 
      "$HOME/.nix-profile/lib" 
      "/run/current-system/sw/lib" 
      "/etc/profiles/per-user/$USER/lib" 
    ]);
in {
    config = lib.mkIf (systemConfig.applications.video-editing.enable && systemConfig.services.pipewire.enable) {
        home.packages = with pkgs; [
            ardour
            drumkv1
            samplv1
            lsp-plugins
            sfizz-ui
        ]; 
        home.sessionVariables = {
            CLAP_PATH   = lib.mkDefault (makePluginPath "clap");
            DSSI_PATH   = lib.mkDefault (makePluginPath "dssi");
            LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
            LV2_PATH    = lib.mkDefault (makePluginPath "lv2");
            LXVST_PATH  = lib.mkDefault (makePluginPath "lxvst");
            VST3_PATH   = lib.mkDefault (makePluginPath "vst3");
            VST_PATH    = lib.mkDefault (makePluginPath "vst");
        };
    };
}
