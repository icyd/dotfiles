{ modulesPath, pkgs, ... }: {
    imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
    ec2.hvm = true;
    environment.systemPackages = with pkgs; [
        binutils
        gcc
        gnumake
        cmake
        autogen
        git
        unzip
        wget
        vim
    ];
    nix = {
        package = pkgs.nixFlakes;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };
    };
    time.timeZone = "Europe/Madrid";
    programs.tmux.enable = true;
    programs.zsh.enable = true;
}
