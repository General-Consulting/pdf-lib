{
  description = "A Nix-flake-based PDF-Lib development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      overlays = [
        (final: prev: rec {
          nodejs = prev.nodejs-18_x;
          pnpm = prev.nodePackages.pnpm;
          yarn = (prev.yarn.override { inherit nodejs; });
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; config.allowUnfree = true; };
      });
    in
    {
      devShells = forEachSupportedSystem
        ({ pkgs }: {
          default = pkgs.mkShell
            {
              packages = with pkgs; [ yarn nodePackages.typescript ];
              shellHook = ''
              '';
            };
        });
    };
}
