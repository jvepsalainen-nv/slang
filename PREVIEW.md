# Shader Coverage + `slang-rhi` Helper Binding Preview (2026-05-07)

This branch is a **customer preview** of the current shader-coverage
stack while the upstream PRs go through review. It exists as a
feedback channel on the fork, not as a merge request. The expected
lifecycle is:

- test the branch
- leave feedback on this preview PR or the upstream PRs
- close the preview PR when the upstream PRs land

Snapshot of:

- [shader-slang/slang#11080](https://github.com/shader-slang/slang/pull/11080)
  - Slang-side hidden binding metadata, helper queries, docs, and late
    coverage materialization
- [shader-slang/slang-rhi#739](https://github.com/shader-slang/slang-rhi/pull/739)
  - `slang-rhi` synthetic-resource binding support for Vulkan and CUDA
- this preview branch
  - a standalone end-to-end demo using the new reflection-binding
    helper functions and `slang-rhi`
  - standalone Vulkan and CUDA demo tests

Related to Slang issue #10794.

## What this preview adds on top of the implementation PRs

The upstream PRs establish the two implementation halves:

- Slang exposes the hidden coverage resource through:
  - `ICoverageTracingMetadata`
  - `ISyntheticResourceMetadata`
  - descriptor helper functions in `slang.h`
- `slang-rhi` consumes that metadata through:
  - `ShaderProgramSyntheticResourcesDesc`
  - `ISyntheticShaderProgram`
  - `bindSyntheticResource(...)`

This preview branch adds a concrete customer-facing example:

- [`examples/shader-coverage-binding-demo`](examples/shader-coverage-binding-demo)

The demo shows:

- multi-file Slang program structure
- a larger compute workload (`100000` items) with nontrivial path distribution
- coverage-enabled compile through the C++ API
- metadata queries through:
  - `ICoverageTracingMetadata`
  - `ISyntheticResourceMetadata`
- Vulkan descriptor helper usage:
  - `findSyntheticResourceDescriptorRangeByID(...)`
- CUDA uniform binding query usage:
  - `getResourceUniformBindingInfo(...)`
- `slang-rhi` program creation using synthetic resource descriptors
- helper-based binding with:
  - `bindSyntheticResource(...)`
- Vulkan and CUDA dispatch, readback, manifest write, and LCOV write
- standalone `ctest` entries for the Vulkan and CUDA demo paths

## Demo layout

The preview demo lives in:

- [`examples/shader-coverage-binding-demo`](examples/shader-coverage-binding-demo)

Key files:

- [README.md](examples/shader-coverage-binding-demo/README.md)
- [CMakeLists.txt](examples/shader-coverage-binding-demo/CMakeLists.txt)
- [main.cpp](examples/shader-coverage-binding-demo/main.cpp)
- [app.slang](examples/shader-coverage-binding-demo/app.slang)
- [physics.slang](examples/shader-coverage-binding-demo/physics.slang)
- [math.slang](examples/shader-coverage-binding-demo/math.slang)

## How to use this preview

1. Check out this Slang preview branch.
2. Check out the companion `slang-rhi` branch:
   - `feature/synthetic-resource-bindings-rhi`
3. Build both repos.
4. Follow the demo README for standalone configure/build/run steps.
5. Leave feedback on:
   - the preview PR if it is about the combined integration story
   - `shader-slang/slang#11080` if it is about Slang-side metadata or helper APIs
   - `shader-slang/slang-rhi#739` if it is about RHI-side layout/binding behavior

## Branch shape

```text
preview/shader-coverage-2026-05-07  (this branch)
├── PREVIEW.md
├── examples/shader-coverage-binding-demo/
└── feature/coverage-synthetic-resource-metadata
    ├── shader-slang/slang#11080
    └── shader-slang/slang-rhi#739  (companion repo / branch)
```

If the upstream PRs change significantly, a fresh dated preview branch
can be cut with the updated stack.
