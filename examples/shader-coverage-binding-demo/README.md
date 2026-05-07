# Shader Coverage Binding Demo

This example is a standalone end-to-end demo for the helper-based
shader coverage binding path.

It is intended to be used together with:

- Slang PR [#11080](https://github.com/shader-slang/slang/pull/11080)
- `slang-rhi` PR [#739](https://github.com/shader-slang/slang-rhi/pull/739)

and is included on the preview branch as a customer-facing integration
walkthrough.

## What it demonstrates

- multi-file Slang module structure:
  - `app.slang`
  - `physics.slang`
  - `math.slang`
- coverage-enabled compile through the Slang C++ API
- hidden coverage binding queries through:
  - `slang::ICoverageTracingMetadata`
  - `slang::ISyntheticResourceMetadata`
- Vulkan descriptor helper usage:
  - `slang::findSyntheticResourceDescriptorRangeByID(...)`
- CUDA uniform binding query usage:
  - `getResourceUniformBindingInfo(...)`
- `slang-rhi` synthetic resource descriptors passed into
  `createShaderProgram()`
- helper-based runtime binding with:
  - `bindSyntheticResource(...)`
- Vulkan and CUDA dispatch, readback, manifest JSON output, and LCOV output

## Build prerequisites

This example is intentionally standalone because it depends on the
companion `slang-rhi` PR branch. It is not wired into the normal
`all-examples` build in this repo.

You need:

- this Slang repo on branch `preview/shader-coverage-2026-05-07`
- a `slang-rhi` checkout on branch `feature/synthetic-resource-bindings-rhi`
- a built Slang tree
- a built `slang-rhi` tree that is using the matching Slang branch

## Configure

From the Slang repo root:

```bash
cmake -S examples/shader-coverage-binding-demo \
      -B examples/shader-coverage-binding-demo/build \
      -DSLANG_RHI_REPO=/path/to/slang-rhi \
      -DSLANG_BUILD_DIR=/path/to/slang/build/Debug \
      -DSLANG_RHI_BUILD_DIR=/path/to/slang-rhi/build-local-slang/Debug
```

Notes:

- `SLANG_REPO` defaults to this checkout
- `SLANG_RHI_REPO` must point at the companion `slang-rhi` checkout
- `SLANG_BUILD_DIR` and `SLANG_RHI_BUILD_DIR` should point at the
  already-built trees you want to run against

## Build

```bash
cmake --build examples/shader-coverage-binding-demo/build -j8
```

## Run

```bash
examples/shader-coverage-binding-demo/build/shader-coverage-binding-demo
```

By default the demo attempts both backends:

- `--device=vulkan`
- `--device=cuda`

You can select one explicitly:

```bash
examples/shader-coverage-binding-demo/build/shader-coverage-binding-demo --device=vulkan
examples/shader-coverage-binding-demo/build/shader-coverage-binding-demo --device=cuda
```

The demo writes its outputs to the current working directory:

- `shader-coverage-binding-demo-vulkan.coverage-mapping.json`
- `shader-coverage-binding-demo-vulkan.lcov`
- `shader-coverage-binding-demo-cuda.coverage-mapping.json`
- `shader-coverage-binding-demo-cuda.lcov`

If a requested backend is not available, the demo prints a `skipped:`
message and exits successfully. This is intentional so the standalone
tests can be present on machines that only have one of the backends.

## Standalone tests

This example registers two standalone `ctest` entries:

- `shader-coverage-binding-demo-vulkan`
- `shader-coverage-binding-demo-cuda`

Run them with:

```bash
ctest --test-dir examples/shader-coverage-binding-demo/build --output-on-failure
```

## Expected result

Observed Vulkan result on this machine:

- output buffer verified for `64` dispatches
- multi-file attribution across:
  - `app.slang`
  - `physics.slang`
  - `math.slang`
- `15` counter slots
- aggregate hits: `768`
- covered lines: `12`
- uncovered lines: `3`

Observed CUDA result depends on CUDA availability. On machines without a
CUDA device the CUDA demo/test is skipped.

## Why this example exists

This demo is the concrete proof point for the current integration
story:

1. Slang exposes the hidden coverage binding contract through metadata
   and helper functions.
2. `slang-rhi` consumes that metadata as synthetic resource descriptors.
3. the host binds the hidden buffer through helper-based binding rather
   than raw descriptor plumbing in the application.
4. the same shader program structure can be exercised through both the
   Vulkan descriptor-backed path and the CUDA uniform-marshaling path.
