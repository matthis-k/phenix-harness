# phenix-harness

Configuration, skills, and orchestration definitions for Phenix.

## What is this?

This repo contains all Phenix configuration data:

- Agent definitions
- Orchestration workflows
- Routing profiles
- Skill files

It produces a configured conductor package that bundles the default runtime configuration.

## Architecture

Phenix uses a three-repo architecture:

1. **phenix-agent-harness** — The Rust conductor binary (runtime)
2. **phenix-harness** (this repo) — Configuration and skills
3. **phenix-nvim** — Neovim frontend (UI only, no config)

## Usage

The preconfigured conductor is built automatically and used by phenix-nvim.

To customize your configuration, fork this repo and modify:
- `config/phenix/runtime.nix` — agents, orchestrations, routing
- `config/phenix/skills/` — skill definitions

## Configuration Loading Priority

The conductor loads configuration in this order (highest to lowest):

1. Runtime API calls (`_phenix/config/load`)
2. CLI arguments (`--config`, `--config-dir`)
3. Environment variables (`PHENIX_CONFIG_FILE`, `PHENIX_SKILLS_DIR`)
4. XDG config discovery (`~/.config/phenix/`)
5. Built-in defaults (empty conductor)
