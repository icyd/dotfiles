{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        battery = {
          disabled = false;
          display = [
            {
              threshold = 100;
              style = "bold green";
              charging_symbol = "󰂅 ";
              discharging_symbol = "󰁹 ";
            }
            {
              threshold = 75;
              style = "bold green";
              charging_symbol = "󰢞 ";
              discharging_symbol = "󰂀 ";
            }
            {
              threshold = 50;
              style = "bold yellow";
              charging_symbol = "󰢝 ";
              discharging_symbol = "󰁾 ";
            }
            {
              threshold = 25;
              style = "bold orange";
              charging_symbol = "󰂇 ";
              discharging_symbol = "󰁼 ";
            }
            {
              threshold = 10;
              style = "bold red";
              charging_symbol = "󰢜 ";
              discharging_symbol = "󰁺 ";
            }
          ];
        };
        command_timeout = 1200;
        haskell.disabled = true;
        nodejs.disabled = true;
        kubernetes.disabled = false;
        time = {
          disabled = false;
          time_format = "%H:%M";
        };
      };
    };
  };
}
