# Default plugin product policy

Status: product configuration contract.

## Purpose

Define how Harness turns the small kernel MVP into the normal Phenix product.

The target source layout may place the kernel, Harness, and first-party plugins in one `phenix-ai` repository. Repository location does not determine plugin hosting or ownership.

The kernel already works with no product plugins. Harness enables richer first-party features and configures their permissions, priorities, bindings, and settings.

## Intrinsic baseline

Harness does not need plugins to provide the kernel's minimum viable behavior:

- flat durable sessions;
- basic immutable artifacts;
- explicit context and skill registration;
- primitive tool/callable execution;
- simple local durable storage for kernel and plugin schemas.

Harness does not duplicate or replace this intrinsic behavior merely to make it configurable.

## Default plugin set

Expected default features include:

```text
default-session-tree
default-context
default-artifact
engineering-skills
default-cli
```

Later defaults may cover filesystem, shell, search, Git, language/model/provider integrations, and other normal product features as their current kernel implementations migrate.

QML, GitHub, richer semantic context/readers, code graphs, or specialized integrations may remain opt-in unless product requirements justify default enablement.

## Hosting policy

Hosting, distribution, and default enablement are independent.

```text
embedded executable
  trusted Rust implementation linked into the selected Phenix product
  enabled by canonical PluginId

external executable
  independent package with manifest + executable
  enabled from exact Nix store path

resource-only
  independent package with manifest + static resources
  enabled from exact Nix store path
```

Most trusted first-party executable defaults should be embedded. Static skill/template/context bundles should be resource-only when they need no executable behavior. A first-party plugin may remain external when it needs independent distribution or enforceable process isolation.

Default status grants no authority and does not select hosting mode.

## Primary Nix UX

Harness policy is exposed through the `nix-wrapper-modules` wrapper exported by `phenix-ai`:

```text
wrappers.phenix
```

The normal product requires only:

```nix
inputs.phenix-ai.wrappers.phenix.wrap {
  inherit pkgs;
}
```

The selected `phenix` binary already contains the normal embedded factory catalog. The wrapper activates Harness defaults and emits immutable runtime configuration.

Users add independently packaged external/resource plugins through the same wrapper:

```nix
inputs.phenix-ai.wrappers.phenix.wrap {
  inherit pkgs;
  plugins = [ inputs.phenix-qml.packages.${pkgs.system}.default ];
}
```

A structured entry adds policy when needed:

```nix
inputs.phenix-ai.wrappers.phenix.wrap {
  inherit pkgs;

  plugins = [
    {
      package = inputs.phenix-qml.packages.${pkgs.system}.default;
      permissions.ipc = [ "qml-debug" ];
      priority."qml.inspect" = 100;
      settings = { };
    }
  ];
}
```

A bare package is shorthand for `{ package = ...; }`.

The wrapper is the authoritative Nix configuration model for Harness policy. It owns default activation, packaged additions, grants, priorities, bindings, settings, generated runtime configuration, and final wrapping.

## Embedded defaults

Embedded implementation availability is build-time. Harness activation is configuration-time.

Harness identifies an embedded plugin by canonical `PluginId`. It never supplies a runtime Rust `.so`, `.dylib`, or `.dll` path.

Changing only enablement, settings, grants, priority, or bindings reuses the same underlying Phenix executable package. Changing embedded implementation bytes rebuilds that product package.

Harness must reject activation of an embedded `PluginId` absent from the selected product build.

The normal product may carry linked implementations that are disabled by configuration.

## Wrapper defaults

Zero-configuration `.wrap` produces the normal Phenix product. Users do not enumerate first-party defaults.

The wrapper exposes one explicit kernel-minimal profile for tests, debugging, and users who want intrinsic behavior only. Kernel-minimal mode disables product feature activation without changing kernel semantics or requiring a different dynamic plugin mechanism.

## Packaged plugin boundary

External executable and resource-only plugins are ordinary immutable Nix packages with runtime manifests.

The package carries code/resources and its manifest. Harness carries effective permissions, provider priorities, explicit bindings, and settings.

A plugin package cannot grant itself authority or selection priority.

`phenix-ai.lib.mkPhenixPlugin` packages these independently distributed forms. It is not the mechanism for loading statically linked Rust crates.

The current Harness flake wrapper/config-generation pattern should converge into `wrappers.phenix` rather than a separate public configuration model.

## Platform adapters

NixOS, Home Manager, nix-darwin, devenv, and flake-parts integration reuse the same wrapper module.

Where `nix-wrapper-modules` provides install-module adapters, use them to install/configure the Phenix wrapper. A convenience adapter may be exported, but it delegates to the wrapper options and resulting package.

Do not maintain separate platform-specific plugin/grant/priority schemas. No overlay is required.

## Session tree

`default-session-tree` adds session lineage/fork navigation and richer session metadata above the kernel's flat session store.

Its state is plugin-owned durable data. In the normal product its Rust implementation should be embedded. Disabling it leaves every kernel session accessible and continuable and does not require relinking the underlying Phenix executable.

Harness may configure other independent session plugins such as tags/search without requiring one monolithic session plugin.

## Context

The kernel can use explicitly registered context without plugins.

`default-context` adds normal project/repository discovery and conservative file-backed context behavior.

Richer semantic, language-aware, repository-aware, or domain-specific providers may replace or augment defined context roles through normal provider policy.

## Artifacts

The kernel can store and recover a basic immutable artifact.

`default-artifact` adds normal reading, reuse/invalidation, dependency, or presentation behavior defined by its contracts.

## Skills

Kernel skill registration and activation work without bundled skills.

`engineering-skills` supplies the default skill library. It should be resource-only unless executable behavior is actually required. Domain plugins may package their own skills beside tools, context, and capabilities.

Skill activation grants no authority.

## Persistence

The normal product uses the kernel's intrinsic local persistence backend unless Harness explicitly selects an alternative persistence-provider plugin.

Default feature plugins register their own durable schemas. Harness does not know their physical tables or database representation.

A remote, replicated, or alternative backend may be selected through the persistence provider contract. Backend selection never changes plugin schema meaning.

## Configuration

Harness wrapper options may define:

For embedded plugins:

- enabled/disabled state by `PluginId`;
- permission grants;
- per-capability/provider priority;
- explicit provider bindings;
- plugin-specific declarative settings.

For external/resource plugins:

- exact package;
- the same policy fields above.

Plugins do not self-assign effective permission or priority.

Default provider priority is `0` unless Harness has a specific reason to choose another value.

## Permissions and trust

Bundled/default status has no trust meaning for authority.

Permissions determine eligibility. Priority chooses among eligible providers. Explicit binding outranks priority but not permission or availability.

Harness grants the minimum authority each default plugin needs.

Embedded native code is trusted from an OS-isolation perspective. A plugin that needs enforceable isolation remains external even if first-party.

## Durable feature state

Plugin state is namespaced and persisted through the kernel durable-data API.

Harness does not define schema internals. It decides whether the owning plugin is enabled and how it is configured.

Disabling a plugin does not delete its durable data. Re-enabling a compatible version may recover it.

## Overrides

Users may use wrapper options to:

- disable default feature plugins;
- select the kernel-minimal profile;
- enable optional linked plugins available in the selected product;
- add an external or resource plugin package;
- change grants within kernel/product bounds;
- change provider priorities;
- explicitly bind provider roles;
- select an alternative persistence backend.

Changes produce a new wrapped derivation and immutable kernel configuration revision. Running executions keep pinned semantics where applicable.

For embedded plugins, runtime configuration pins selected product identity plus plugin ID/manifest/config identity. For external/resource plugins, it additionally pins exact store paths.

## Failure behavior

Missing optional packaged plugins do not block startup unless configured as required.

An embedded plugin configured as required but absent from the selected product is a clear configuration error. Harness does not silently restore old kernel feature paths, dynamically load Rust libraries, or broaden permissions.

The kernel intrinsic MVP remains available independently of missing default feature plugins.

## Product ownership

Inside the target `phenix-ai` source layout:

- `phenix-kernel` owns intrinsic behavior and plugin contracts;
- first-party plugin crates/resources own feature implementations/content;
- product assembly links the embedded factory catalog into `phenix`;
- `phenix-harness` owns default activation and policy.

The kernel crate does not depend on concrete default plugin crates.

## Invariants

- Harness adds product richness; it does not define kernel correctness.
- `wrappers.phenix` is the primary Nix Harness interface.
- Zero-config `.wrap` produces the normal default product.
- Kernel-minimal mode is explicit.
- Platform integrations adapt the same wrapper options.
- Embedded availability is build-time; Harness enablement is configuration-time.
- Most trusted first-party executable defaults are statically linked factories.
- Resource-only defaults need no fake executable.
- External plugins are used for independent distribution or enforceable isolation.
- Rust dynamic libraries are not a plugin format.
- Flat sessions remain valid without `default-session-tree`.
- Basic artifacts, context, and skills remain operable without their default feature plugins.
- Default plugin durable state uses namespaced kernel schemas.
- Packaged plugins are pinned by exact store paths.
- Bundled status grants no permission or priority.
- Repository co-location does not weaken plugin boundaries.
- Harness keeps no second plugin, capability, or primitive registry.

## Required regressions

- `wrappers.phenix.wrap { inherit pkgs; }` builds the normal default product;
- explicit kernel-minimal wrapper configuration starts with all product feature plugins disabled;
- wrapper can enable/disable a linked default by `PluginId`;
- enabling an unavailable embedded `PluginId` fails clearly;
- changing only embedded policy reuses the same underlying Phenix executable package;
- bare external/resource plugin packages work through the wrapper;
- structured wrapper plugin configuration applies grants, priority, and settings;
- platform install adapters produce the same wrapped package semantics;
- built runtime configuration pins selected product identity and exact packaged plugin store paths;
- disabling session-tree removes tree/navigation only;
- disabling default-context leaves explicit context working;
- disabling default-artifact leaves basic artifact storage/recovery working;
- engineering skills disappear when disabled while skill registration remains available;
- plugin durable state survives compatible disable/re-enable;
- optional provider replaces only its declared role and cannot expand authority;
- alternative persistence backend stores the same registered kernel/plugin schema semantics;
- no runtime Rust dylib loading occurs.

## Dependency

Implementation follows the intrinsic baseline, generic durable-data, plugin host/resolution, embedded/external hosting, blocking-threaded runtime, and wrapper-module Nix packaging contracts from `matthis-k/phenix-conductor#398`.

## PR boundary

Harness implementation follows kernel feature-plugin migrations. Move the current wrapper/config-generation behavior into `wrappers.phenix`, activate embedded defaults by `PluginId`, add external/resource packages by exact store path, and avoid parallel Nix configuration paths.
