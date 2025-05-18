{
  description = "My custom app icons";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "custom-icons";
          version = "0.1";

          src = ./.;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/icons/hicolor/256x256/apps
            cp -r icons/hicolor/256x256/apps/* $out/share/icons/hicolor/256x256/apps/

            runHook postInstall
          '';

          meta = with nixpkgs.lib; {
            description = "Custom app icons for my apps";
            homepage = "https://github.com/sachesi/desktop-thumbnailer/";
            license = pkgs.lib.licenses.free;
            maintainers = [
              {
                name = "sachesi x";
                email = "sachesi.bb.passp@proton.me";
                github = "sachesi";
              }
            ];
            platforms = platforms.linux;
          };
        };
      }
    );
}
