{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = "[](#3B4252)$python$hostname[](bg:#434C5E fg:#3B4252)$directory[](fg:#434C5E bg:#4C566A)$git_branch$git_status[](fg:#4C566A bg:#86BBD8)$golang$rust[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";

      hostname = {
        ssh_only = false;
        style = "bg:#3B4252";
        format = "[$hostname ]($style)";
        disabled = false;
      };

      directory = {
        style = "bg:#434C5E";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#4C566A";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#4C566A";
        format = "[$all_status$ahead_behind ]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[[ $symbol ($version) ]($style)";
      };

      python = {
        style = "bg:#86BBD8";
        format = "[[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:#06969A";
        format = "[[ $symbol $context ]($style) $path";
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[ $time ]($style)";
      };
    };
  };
}