# Shader Coverage — Customer Preview (2026-04-24)

This branch is a snapshot of two stacked upstream pull requests that
together deliver `-trace-coverage`, an end-to-end shader-coverage
instrumentation feature for Slang:

- **PR [#10886]** — compiler groundwork (AST-time buffer synthesis, IR
  instrumentation pass, `ICoverageTracingMetadata` public API,
  `.coverage-mapping.json` sidecar)
- **PR [#10897]** — runtime helper library (`slang-coverage-rt`) and
  example (`examples/shader-coverage-demo`)

[#10886]: https://github.com/shader-slang/slang/pull/10886
[#10897]: https://github.com/shader-slang/slang/pull/10897

## Updates since the first preview (2026-04-27 onward)

- **`-trace-coverage-binding <index> <space>` CLI flag.** Pins the
  synthesized `__slang_coverage` buffer at an explicit
  `(register, space)` slot at compile time. Useful when the host
  needs the slot fixed before reflection runs (e.g. pre-built D3D12
  root signatures). Implies `-trace-coverage`.
  - **Status of non-zero descriptor space:** the underlying Slang
    reflection bug (`_findOrAddDescriptorSet` not populating
    `DescriptorSetInfo::spaceOffset`) is **fixed in this preview**.
    D3D12 now handles `--coverage-binding=N:M` end-to-end for any
    `M`. Vulkan / WebGPU remain pending a slang-rhi follow-up
    (binding-data builder assumes ≤ 1 descriptor set per shader
    object); the demo skips dispatch with a clear `[coverage] skip`
    message on those backends rather than letting the assertion
    fire mid-dispatch. Tracked as
    [shader-slang/slang#10959](https://github.com/shader-slang/slang/issues/10959).
- **`slang-coverage-rt` API alignment with the rest of Slang.**
  Functions now return `SlangResult` (not the previous
  `SlangCoverageResult` enum); error codes map to `SLANG_E_*`
  constants; `SlangCoverageBindingInfo` gained a leading
  `size_t structSize` field for ABI-versioned struct growth. **If
  your host code from the previous preview compares results against
  `SLANG_COVERAGE_OK`, switch to `SLANG_OK` (or `!SLANG_FAILED(r)`).**
- **Multi-module synthesis dedup.** Multi-file shaders (e.g.
  `simulate.slang` + `import physics`) used to synthesize one
  `__slang_coverage` per module, which collided on the explicit slot
  with `-trace-coverage-binding`. Fixed: the synthesizer walks
  transitively imported modules and reuses an existing buffer.
- **Counter-buffer compaction.** Purely structural compound
  statements (`BlockStmt`, `SeqStmt`) no longer get their own
  counter slots, since their per-line hits collapse into the same
  records as their child statements anyway. Counter buffer is
  ~30–50% smaller on deeply nested shaders without changing LCOV
  output semantics.
- **`Diagnostics::CoverageBufferWrongType` (warning E45100).** A
  user-declared `__slang_coverage` with the wrong type now produces
  a registered diagnostic anchored at the user's declaration source
  location instead of a raw warning string.

## What this branch is for

This is a **preview for customer integration testing** while the
upstream PRs go through review. Try the demo end-to-end, integrate
the feature into your own build if you like, and leave feedback on
the PR this branch is attached to.

## Stability contract

- **The branch may be rebased onto newer upstream-PR fixes.** When
  upstream PRs #10886 / #10897 advance, this branch follows so the
  preview keeps reflecting the latest reviewed state. That requires
  a force-push from time to time. If your local clone errors on
  `git pull` because of a divergent history, refresh with:

  ```bash
  git fetch origin preview/shader-coverage-2026-04-24
  git reset --hard origin/preview/shader-coverage-2026-04-24
  ```

  (Recommended: don't develop on this branch directly; integrate
  against the feature in your own branch and pull updates here as
  needed.)
- The branch will not be deleted while the upstream PRs are open.
- When the upstream PRs land, this branch will be archived and you
  can switch to the released version.

## Backend support matrix

| Backend | Default `-trace-coverage` | `-trace-coverage-binding=N:0` | `-trace-coverage-binding=N:M` (M ≠ 0) |
|---|---|---|---|
| CPU | Supported | (no-op — backend uses uniform offsets) | (no-op) |
| Vulkan (incl. MoltenVK on macOS) | Supported | Supported | Skipped — demo prints `[coverage] skip` until slang-rhi follow-up lands |
| D3D12 | Supported | Supported | Supported (compiler reflection fix landed; root signature accepts the layout) |
| CUDA | Supported | (no-op — backend uses uniform offsets) | (no-op) |
| Metal (direct) | Pipeline runs; counter values unreliable due to a pre-existing slang-rhi binding quirk. Not a coverage-feature bug — tracked at [shader-slang/slang-rhi#724](https://github.com/shader-slang/slang-rhi/issues/724). Use Vulkan via MoltenVK on Apple silicon. | (untested) | (untested) |

The Vulkan / WebGPU non-zero-space gap is a slang-rhi follow-up
(binding-data builder assumes ≤ 1 descriptor set per shader
object). Tracked alongside the compiler fix at
[shader-slang/slang#10959](https://github.com/shader-slang/slang/issues/10959).

Expected demo output (default binding, mixed scenario): a
non-trivial LCOV report where the unreachable `"unknown type"`
error-branch in `simulate.slang` shows zero hits — that's the
dead-code-detection signal the feature exists to surface.

## Build

First-time builds take 5–20 minutes depending on machine. Subsequent
incremental builds are ~seconds. If you iterate often, set
`-DSLANG_USE_SCCACHE=ON` at configure time for faster rebuilds.

### Linux / macOS

```bash
git clone --branch preview/shader-coverage-2026-04-24 \
    --recurse-submodules \
    https://github.com/jvepsalainen-nv/slang.git
cd slang
cmake --preset default
cmake --build --preset debug --target shader-coverage-demo
```

### Windows

```powershell
git clone --branch preview/shader-coverage-2026-04-24 `
    --recurse-submodules `
    https://github.com/jvepsalainen-nv/slang.git
cd slang
cmake --preset vs2022 -DSLANG_IGNORE_ABORT_MSG=ON
cmake --build --preset debug --target shader-coverage-demo
```

## Run the demo

```bash
# Pick any of: cpu, vulkan, d3d12, cuda
./build/Debug/bin/shader-coverage-demo --mode=dispatch --backend=cpu
# -> produces coverage.lcov and simulate.coverage-mapping.json
```

## Render the LCOV report

### Linux

```bash
sudo apt install lcov
genhtml coverage.lcov -o coverage-html/
xdg-open coverage-html/index.html
```

### macOS

```bash
brew install lcov
genhtml coverage.lcov -o coverage-html/
open coverage-html/index.html
```

### Windows (no Perl required)

```powershell
dotnet tool install --global dotnet-reportgenerator-globaltool
reportgenerator -reports:coverage.lcov -targetdir:coverage-html -reporttypes:Html
start coverage-html\index.html
```

## Integrating into your own host

If you have a Vulkan / D3D12 / CUDA host that runs compiled Slang
shaders and you want to add coverage *without* using the demo's
slang-rhi path, see the "SPIR-V integration" section of
[`examples/shader-coverage-demo/README.md`][demo-readme] — ~30 lines
of additional host code, no new runtime dependency beyond
`libslang-coverage-rt`.

[demo-readme]: examples/shader-coverage-demo/README.md

## Further reading

- **Architecture**: [`docs/design/shader-coverage.md`][arch]
- **Demo usage**: [`examples/shader-coverage-demo/README.md`][demo-readme]
- **Runtime library**: [`source/slang-coverage-rt/README.md`][rt-readme]
- **Tools + CLI reference**: [`tools/shader-coverage/README.md`][tools-readme]

[arch]: docs/design/shader-coverage.md
[rt-readme]: source/slang-coverage-rt/README.md
[tools-readme]: tools/shader-coverage/README.md

## How to give feedback

- **Line-specific comments**: open the files-changed tab on this PR
  and click the `+` next to any line. Great for "why does this do X?"
  or "this header is unclear" feedback.
- **Broader threads**: comment on the PR's main Conversation tab.
- **Build / run issues**: mention `@jvepsalainen-nv` on the PR with
  your OS, compiler, and the error output.
- **Integration questions**: also welcome on the PR — we can discuss
  there and, if useful, promote the answer into the docs above.

All feedback on this branch flows back into the upstream PRs
(#10886 / #10897) so it lands in the final shipped version.
