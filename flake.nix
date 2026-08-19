{
  description = "Phenix configuration and agent definitions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    phenix-agent-harness.url = "github:matthisk/phenix-agent-harness";
  };

  outputs = { self, nixpkgs, flake-utils, phenix-agent-harness }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        conductor = phenix-agent-harness.packages.${system}.phenix-conductor;
        
        # Build the preconfigured conductor with embedded config
        configuredConductor = pkgs.stdenv.mkDerivation {
          pname = "phenix-conductor-configured";
          version = "0.1.0";
          
          buildInputs = [ pkgs.makeWrapper ];
          
          # Copy the base conductor and add config wrapper
          buildCommand = ''
            mkdir -p $out/bin
            cp ${conductor}/bin/phenix-conductor $out/bin/
            chmod +x $out/bin/phenix-conductor
            
            # Create wrapper that sets config environment
            makeWrapper $out/bin/phenix-conductor $out/bin/phenix-conductor-configured \
              --set PHENIX_CONFIG_FILE "${self.lib.config.x86_64-linux}" \
              --set PHENIX_SKILLS_DIR "${self.lib.skillsDir}"
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
        # Raw config file (built from runtime.nix)
        config = {
          x86_64-linux = let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
          in pkgs.writeText "phenix-runtime.json" (builtins.toJSON (import ./config/phenix/runtime.nix));
          aarch64-linux = let
            pkgs = nixpkgs.legacyPackages.aarch64-linux;
          in pkgs.writeText "phenix-runtime.json" (builtins.toJSON (import ./config/phenix/runtime.nix));
          x86_64-darwin = let
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          in pkgs.writeText "phenix-runtime.json" (builtins.toJSON (import ./config/phenix/runtime.nix));
          aarch64-darwin = let
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          in pkgs.writeText "phenix-runtime.json" (builtins.toJSON (import ./config/phenix/runtime.nix));
        };
        
        # Skills directory path
        skillsDir = ./config/phenix/skills;
        
        # Raw runtime.nix for import
        runtimeNix = ./config/phenix/runtime.nix;
      };
    };
}
