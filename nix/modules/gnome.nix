{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];
  environment.gnome.excludePackages = (
    with pkgs; [
      gedit
      gnome-photos
      gnome-tour
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]
  );
  programs.dconf.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  services.gnome.at-spi2-core.enable = true;
}
