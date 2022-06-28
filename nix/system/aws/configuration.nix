{ config, pkgs, username, stateVersion, modulesPath, ... }: {
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
    programs.mosh.enable = true;
    programs.tmux.enable = true;
    programs.zsh.enable = true;
    system.stateVersion = stateVersion;
    time.timeZone = "Europe/Madrid";
    users.defaultUserShell = pkgs.zsh;
}
