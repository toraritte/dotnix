{ lib, pkgs, ... }:
let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux;
  caches = import ./caches.nix;
  nixpkgsConfig = ./nixpkgs-config.nix;
  overlays =
    let
      path = ../../overlays;
    in
      with builtins;
      map (n: import (path + ("/" + n)))
        (
          filter (
            n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))
          )
            (attrNames (readDir path))
        );
in

{
  imports = [
    (if isLinux then ./nixos.nix else ./darwin.nix)
  ];

  #############################################################################
  # System-level configuration.

  time.timeZone = "America/New_York";

  nixpkgs = {
    inherit overlays;
    config = import nixpkgsConfig;
  };

  nix = {
    binaryCaches = caches.substituters;
    binaryCachePublicKeys = caches.keys;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';

    # Auto-upgrade Nix package; use latest version (i.e. with flakes support).
    package = pkgs.nixFlakes;
  };

  #############################################################################
  # User-level configuration.
  primary-user.home-manager = {
    nixpkgs = {
      inherit overlays;
      config = import nixpkgsConfig;
    };

    xdg = {
      enable = true;
      configFile."nixpkgs/config.nix".source = nixpkgsConfig;
      configFile."nix/nix.conf".text = ''
        experimental-features = nix-command flakes ca-references
        substituters = ${toString caches.substituters}
        trusted-public-keys = ${toString caches.keys}
      '';
    };
  };
}
