# CUDA back end: compile-time optimization opportunities

Working document for [#12962](https://github.com/shader-slang/slang/issues/12962),
under [#12941](https://github.com/shader-slang/slang/issues/12941).

**Status: half finished, and the half that is missing needs a CUDA machine.**
Everything below was measured on macOS arm64, which has no CUDA toolkit, so
every number is Slang's own work emitting `.cu` source. Nothing downstream of
that -- nvrtc, PTX, cubin, or anything on a GPU -- has been measured at all.
§5 is the plan for finishing it.

---

## 1. Scope: what is measured here, and what is not

|                                                      | measured | how                                                                                             |
| ---------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------- |
| Slang front end + IR pipeline + CUDA source emission | **yes**  | `-target cuda`, `-report-detailed-perf-benchmark`                                               |
| nvrtc / PTX downstream compile                       | **no**   | needs nvrtc; `-target ptx` fails here with `E00100: failed to load downstream compiler 'nvrtc'` |
| cubin / link / module load                           | **no**   | needs the CUDA toolkit                                                                          |
| Kernel runtime                                       | **no**   | needs a GPU                                                                                     |
| OptiX path                                           | **no**   | not exercised by any workload                                                                   |

This matters for prioritization, because the unmeasured half may well be the
larger one. `lib/manifest.py` records, on the `codegen_dxil`/`codegen_ptx`
workloads, that _"an internal application benchmark showed downstream time is
~60% of a real app's combined compile time"_. If that holds for CUDA, then
everything in §3 is an optimization of the smaller 40%.

Treat §3 as "what is known to be wrong in the part we can see", not as a
ranked list of where CUDA compile time actually goes.

---

## 2. The shape that makes CUDA different

CUDA is a global-context-packing target. `introduceExplicitGlobalContext`
merges the module's shader parameters into a single struct and rewrites every
access into a load from it, inside the function that uses them. A shader with
N resources therefore produces **N loads concentrated in one function body**.

SPIR-V does not do this -- parameters stay as globals, and a resource access
is not an `IRLoad` at all. HLSL and WGSL likewise. That single structural
difference is the origin of every CUDA-specific finding below: the IR the
CUDA path hands to the target-independent optimizer is shaped differently, and
the optimizer's cost is super-linear in exactly that shape.

It is worth being explicit that the packing itself is **not** the problem.
`introduceExplicitGlobalContext` measures 0.02 ms. The problem is what the
passes downstream of it do with the result.

---

## 3. What the data shows

Measured on the v2026.17.1 release binary, complexity sweep, `compileInner`
medians. `N` is resources (or matrix ops) in one entry point:

| workload                              |   N |   compileInner |    scaling | vs SPIR-V | dominant pass                                    |
| ------------------------------------- | --: | -------------: | ---------: | --------: | ------------------------------------------------ |
| `resource_aggregate` (SPIR-V control) | 640 |       198.8 ms |     N^0.79 |      1.0x | — (nothing over 34 ms)                           |
| `resource_aggregate_cuda`             | 640 | **13595.6 ms** | **N^2.60** | **68.4x** | `deferBufferLoad` 13327 ms                       |
| `backend_loads_spirv` (control)       | 640 |        91.5 ms |     N^0.73 |      1.0x | —                                                |
| `backend_loads_cuda`                  | 640 |  **4195.7 ms** | **N^2.49** | **45.8x** | `deferBufferLoad` 2026 + `simplifyNonSSAIR` 2043 |
| `backend_matrix_spirv` (control)      | 512 |       141.0 ms |     N^0.78 |      1.0x | —                                                |
| `backend_matrix_cuda`                 | 512 |  **1973.9 ms** | **N^1.98** | **14.0x** | `simplifyNonSSAIR` 1254 + `deferBufferLoad` 573  |

Two passes account for essentially all of it, and both are reached through the
same machinery -- `removeRedundancy` -> `removeRedundancyInFunc` ->
`eliminateRedundantLoadStore`, whose scans are O(n) per load/store and whose
per-query costs were unmemoized:

- **`deferBufferLoad`** is CUDA-specific in practice. It calls
  `removeRedundancyInFunc` on every function before doing its own work, and on
  this target that function contains N loads.
- **`simplifyNonSSAIR`** is cross-target: it runs the same machinery again
  after phi elimination. It is the second-largest single pass across the whole
  compile-perf suite.

### CUDA missed the window's improvements

`backend_loads` at N=320, cuda/spirv ratio per release:

| release      | v2026.12 | v2026.13 | v2026.14 | v2026.16 | v2026.17 | v2026.17.1 |
| ------------ | -------: | -------: | -------: | -------: | -------: | ---------: |
| cuda / spirv |    2.15x |    2.21x |    3.32x |    3.47x |    3.35x |  **3.53x** |

The ratio widened not because CUDA got slower but because everything else got
faster. Across those six releases `deferBufferLoad` held at 63-68 ms and
`simplifyNonSSAIR` at 63-67 ms, while the SPIR-V control's entire
`linkAndOptimizeIR` fell from 57.7 ms to 14.6 ms.

An earlier bisect on a texture-load shader put the original step between
v2026.2 and v2026.8.1: 144 ms -> 2075 ms at N=512, still ~1695 ms at v2026.17.

### What the two fixes in flight recover

Measured on a local dev build (so absolute values differ from the release
binary above; the ratios are what to read):

| workload                  |   N |     before | + #13012 | + #13013 |     total |
| ------------------------- | --: | ---------: | -------: | -------: | --------: |
| `resource_aggregate_cuda` | 640 | 10242.8 ms |    532.7 |    521.6 | **19.6x** |
| `backend_loads_cuda`      | 640 |  3714.3 ms |    208.6 |    203.6 | **18.2x** |
| `backend_matrix_cuda`     | 512 |  2029.7 ms |    345.2 |    330.8 |  **6.1x** |
| `resource_aggregate_cuda` | 320 |  1519.4 ms |    200.0 |    190.9 |  **8.0x** |

- **#13012** memoizes the per-callee side-effect query (the cubic term). Almost
  all of the win.
- **#13013** removes per-query heap allocation in the aliasing check. Marginal
  on CUDA; it is the Metal/GLSL half.

**After both, CUDA is still 1.5-2.1x SPIR-V on the same source**, and
`deferBufferLoad` is still 255 ms of the 522 ms `resource_aggregate_cuda`
compile -- **49%**. The cubic is gone; the quadratic is not.

---

## 4. Opportunities, in priority order

**P1 — Remove the O(n²) scan (helps every target, CUDA most).**
`tryRemoveRedundantLoad` walks backward to the top of the block per load;
`tryRemoveRedundantStore` walks forward, across unconditional branches. With
#13012 and #13013 merged, this scan _is_ the remaining cost. The fix is to
replace it with a single-pass last-clobber / available-value analysis
(effectively a lightweight MemorySSA). This is the largest and most
correctness-sensitive item and deserves its own design discussion. Evidence:
`deferBufferLoad` at 49% of a post-fix CUDA compile, and Metal still at N^1.70.

**P2 — Ask whether `deferBufferLoad` needs `removeRedundancyInFunc` at all.**
It calls it on every function before its own work. If it only needs redundancy
removal on the functions it will actually transform, or only on the loads it
is about to defer, the cost collapses without touching the shared analysis.
This is cheap to investigate and may be most of P1's benefit for CUDA
specifically.

**P3 — Ask whether the global context must materialize N loads.**
`introduceExplicitGlobalContext` is itself free (0.02 ms), but the IR it
produces is what everything downstream struggles with. If parameter accesses
could stay as field addresses and be loaded at the point of use, or be
SROA'd/deduplicated before the redundancy passes run, the shape that causes
the problem would not exist. Bigger design question; note that the pass has a
real purpose (CUDA has no global shader parameters) so this is about _form_,
not whether to do it.

**P4 — Measure the downstream (see §5).** Potentially ~60% of real compile
time and currently a complete blind spot. This should arguably be P1 for
_knowing where the time goes_; it is P4 only because nothing here can act on
it yet.

### Checked and ruled out — do not re-investigate

Every CUDA-specific pass in the detailed timer output, at the largest sizes
measured, sits under 1.5 ms and is not worth attention:

| pass                                     | measured |
| ---------------------------------------- | -------: |
| `legalizeEntryPointVaryingParamsForCUDA` |  0.86 ms |
| `lowerImmutableBufferLoadForCUDA`        |  0.23 ms |
| `synthesizeActiveMask`                   |  0.04 ms |
| `undoParameterCopy`                      |  0.03 ms |
| `collectOptiXEntryPointUniformParams`    |  0.03 ms |
| `introduceExplicitGlobalContext`         |  0.02 ms |

The plain CUDA **emitter** is also fine. On `emit_cuda` (a construct-free math
shader) CUDA is 91-94 ms against SPIR-V's 75-81 ms, about 1.2x -- the text
emission path is not a problem. It is specifically the resource/global-context
shape that hurts.

---

## 5. What only a CUDA machine can answer

Prerequisites: a build of Slang with CUDA available, and nvrtc on the library
path. Confirm with `slangc x.slang -target ptx -o x.ptx`; if it reports
`E00100: failed to load downstream compiler 'nvrtc'` the rest will not work.

### 5a. Split Slang time from nvrtc time

`codegen_ptx` is the only workload that goes through the downstream compiler.
It is marked `platforms=["win32"]`, so it is excluded from the default set --
but `bench.py` runs a platform-bound workload when it is named explicitly, and
fails loudly if the tool is genuinely absent (`downstream_required`):

```bash
cd tools/compile-perf
python3 bench.py --slangc <slangc> --label cuda-host --samples 5 \
    --only codegen_ptx,emit_cuda,codegen_spirv
```

`wall_ms` is end-to-end; `compileInner` is Slang-internal. **`wall_ms -
compileInner` is approximately the downstream share** (plus process startup,
which `minimal` bounds). If that share is anywhere near the ~60% the manifest
cites, P4 becomes P1.

If `codegen_ptx` will not run on Linux because of the `platforms` gate, the
one-line change is to widen it — worth doing anyway, since the suite currently
has no CUDA downstream coverage outside Windows.

### 5b. Does the downstream also scale badly on the resource shape?

The interesting question is whether nvrtc is _also_ super-linear in the N-loads
shape, or whether it is only Slang. Generate the same ladders and send them
through PTX:

```bash
python3 bench.py --slangc <slangc> --label cuda-sweep --samples 5 --sweep \
    --only backend_loads_cuda,resource_aggregate_cuda,backend_matrix_cuda
python3 sweep_report.py --label cuda-sweep
```

then repeat with `-target ptx` to get the downstream curve. If Slang is
N^2.5 and nvrtc is linear, P1/P2 are the whole story. If nvrtc is also
super-linear on this shape, the emitted code itself is the problem and P3
becomes the important one.

### 5c. Is the emitted CUDA good?

Nothing here has looked at the _quality_ of the emitted `.cu`, only the time
to produce it. Worth checking on a machine that can compile and run it:

- register pressure and occupancy for the global-context struct form,
  especially whether the N loads survive into the generated PTX or are folded;
- whether `undoParameterCopy` and `transformParamsToConstRef` are achieving
  what they intend on large parameter structs;
- the OptiX path, which no workload covers at all.

### 5d. Re-measure §3 with a real toolchain

All of §3 should be re-run on the CUDA machine to confirm the source-emission
findings hold there and are not an artifact of this platform. The sweep in 5b
covers it.

---

## 6. Reproducing §3 without CUDA

Everything in §3 is reproducible on any machine, since it needs no toolkit:

```bash
cd tools/compile-perf
python3 bench.py --slangc <slangc> --label x --samples 5 --sweep \
    --only backend_loads_cuda,backend_loads_spirv,resource_aggregate_cuda,\
resource_aggregate,backend_matrix_cuda,backend_matrix_spirv

# per-pass attribution for a single point
<slangc> <generated>.slang -target cuda -o out.cu -report-detailed-perf-benchmark
```

The `backend_*` workloads and the `resource_aggregate` target variants come
from #13009. The cross-release table in §3 came from
`fetch_releases.py --tags v2026.12,v2026.13,v2026.14,v2026.16,v2026.17,v2026.17.1`
followed by `sweep.py --only <those workloads>`.

Related: issue #13010 (the super-linearity), PRs #13012 and #13013 (the two
fixes), #13009 (the workloads that expose it), and
`COVERAGE-ANALYSIS.md` for how the back-end gap was found in the first place.
