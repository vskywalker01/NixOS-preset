{ 
  general = {
    desiredgov="performance";
    defaultgov="powersave";

    reaper_freq=5;
    igpu_desiredgov="performance";
    igpu_power_threshold=0.3;
    softrealtime="on"; 
    ioprio=0;
    inhibit_screensaver=1;
    disable_splitlock=1;
  };
  cpu = {
    pin_cores="yes";
  };
  custom = {
    start = "powerprofilesctl set performance"; 
    end = "powerprofilesctl set balanced";
  };
}
