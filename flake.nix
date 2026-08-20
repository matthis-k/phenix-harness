{
  description = "Phenix configuration and agent definitions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    phenix-conductor.url = "github:matthis-k/phenix-conductor";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      phenix-conductor,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        conductor = phenix-conductor.packages.${system}.default;

        runtimeConfig = pkgs.writeText "phenix-runtime.json" (
          builtins.toJSON (import ./config/phenix/runtime.nix)
        );

        configuredConductor = pkgs.stdenv.mkDerivation {
          pname = "phenix-conductor-configured";
          version = "0.1.0";

          nativeBuildInputs = [ pkgs.makeWrapper ];

          buildCommand = ''
            mkdir -p "$out/bin" "$out/share/phenix/skills"

            cp ${runtimeConfig} "$out/share/phenix/runtime.json"
            cp -r ${./config/phenix/skills}/* "$out/share/phenix/skills/" 2>/dev/null || true

            makeWrapper ${conductor}/bin/phenix-conductor "$out/bin/phenix-conductor" \
              --add-flags "--configuration $out/share/phenix/runtime.json" \
              --set PHENIX_SKILL_PATH "$out/share/phenix/skills"
          '';
        };
      in
      {
        packages = {
          phenix-conductor-configured = configuredConductor;
          default = configuredConductor;
        };

        apps = {
          phenix-conductor-configured = {
            type = "app";
            program = "${configuredConductor}/bin/phenix-conductor";
          };
          default = {
            type = "app";
            program = "${configuredConductor}/bin/phenix-conductor";
          };
        };
      }
    )
    // {
      lib = {
        runtimeNix = ./config/phenix/runtime.nix;
        skillsDir = ./config/phenix/skills;
      };
    };
}
