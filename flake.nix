{
  description = "jkachmar's personal dotfiles and machine configurations";

  inputs = {
    # Stable Darwin nixpkgs package set; pinned to the 20.03 release.
    darwin.url = "github:nixos/nixpkgs-channels/nixpkgs-20.03-darwin";
    # Stable NixOS nixpkgs package set; pinned to the 20.03 release.
    stable.url = "github:nixos/nixpkgs-channels/nixos-20.03-small";
    # Unstable nixpkgs package set.
    #
    # More recent than the stable set, the results are likely to be cached.
    unstable.url = "github:nixos/nixos-unstable-small";
    # Primary nixpkgs development repository
    #
    # Most recent package set, however the results are unlikely to be cached.
    trunk.url = "github:nixos/nixpkgs";
    # TODO: Switch to nix-darwin's main branch when flakes have been merged.
    nix-darwin.url = "github:LnL7/nix-darwin/flakes";
    home-manager.url = "github:nix-community/home-manager";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs: {
    nixosConfigurations = {
      star-platinum = {}
    };

    darwinConfigurations = {
      crazy-diamond = {}
    };
  };
}
