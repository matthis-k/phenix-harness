{
  description = "Phenix configuration and agent definitions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    phenix-conductor.url = "github:matthisk/phenix-conductor";
  };

  outputs = { self, nixpkgs, flake-utils, phenix-conductor }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        conductor = phenix-conductor.packages.${system}.default;
        
        # Build the runtime.json config file
        runtimeConfig = pkgs.writeText "phenix-runtime.json" (
          builtins.toJSON (import ./config/phenix/runtime.nix)
        );

        # Build the preconfigured conductor
        # The conductor discovers skills via ContextRegistry::discover(&cwd)
        # which scans: ~/.config/phenix/skills/, <project>/.phenix/skills/, $PHENIX_SKILL_PATH
        # We pass the runtime config via --configuration at the call site (package.nix)
        configuredConductor = pkgs.stdenv.mkDerivation {
          pname = "phenix-conductor-configured";
          version = "0.1.0";
          
          buildInputs = [ pkgs.makeWrapper ];
          
          buildCommand = ''
            mkdir -p $out/bin $out/share/phenix
            
            # Copy the base conductor binary
            cp ${conductor}/bin/phenix-conductor $out/bin/
            chmod +x $out/bin/phenix-conductor
            
            # Copy the runtime config to a known location
            cp ${runtimeConfig} $out/share/phenix/runtime.json
            
            # Copy skills to a standard location that can be referenced via PHENIX_SKILL_PATH
            mkdir -p $out/share/phenix/skills
            cp -r ${./config/phenix/skills}/* $out/share/phenix/skills/ 2>/dev/null || true
          '';
        };
      in
      {
        packages = {
          phenix-conductor-configured = configuredConductor;
          default = configuredConductor;
        };
      }
    ) // {
      # Library exports for customization
      lib = {
        # Raw runtime.nix for import
        runtimeNix = ./config/phenix/runtime.nix;
        
        # Skills directory (for PHENIX_SKILL_PATH)
        skillsDir = ./config/phenix/skills;
      };
    };
}
