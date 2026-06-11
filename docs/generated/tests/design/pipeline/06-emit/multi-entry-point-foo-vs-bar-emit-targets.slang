//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=3250005059a2746ebc504a9d3f71ed112f1f2b94
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#emit-dispatcher
//META: doc_section_digest=05e360846fc3ee11f7582f6896e802ffbb7981b023d417a3b600718f4844ea5b
//META: purpose=Boundary: when the same source has two compute entry points, compiling with `-entry foo` produces foo's body (and not bar's), and `-entry bar` produces bar's body (and not foo's). The dispatcher routes a single entry per compile.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the single-entry-routing claim onto GLSL, Metal, SPIR-V,
// and WGSL — the HLSL sibling (multi-entry-point-foo-vs-bar-emit.slang)
// only proves the dispatcher on HLSL. Each entry carries a distinct
// numthreads value (8 vs 16) and writes a distinct constant (11 vs 22),
// so the per-target emit for `-entry foo` must show foo's marks and NOT
// bar's, and vice versa. GLSL mangles both entry names to `main`, so
// there the local-workgroup size + the stored constant distinguish them.

//TEST:SIMPLE(filecheck=GLSL_FOO):-target glsl -entry foo -stage compute
//TEST:SIMPLE(filecheck=GLSL_BAR):-target glsl -entry bar -stage compute
//TEST:SIMPLE(filecheck=METAL_FOO):-target metal -entry foo -stage compute
//TEST:SIMPLE(filecheck=METAL_BAR):-target metal -entry bar -stage compute
//TEST:SIMPLE(filecheck=SPIRV_FOO):-target spirv-asm -entry foo -stage compute
//TEST:SIMPLE(filecheck=SPIRV_BAR):-target spirv-asm -entry bar -stage compute
//TEST:SIMPLE(filecheck=WGSL_FOO):-target wgsl -entry foo -stage compute
//TEST:SIMPLE(filecheck=WGSL_BAR):-target wgsl -entry bar -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void foo(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 11;
}

[shader("compute")]
[numthreads(16, 1, 1)]
void bar(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 22;
}

// GLSL_FOO: local_size_x = 8
// GLSL_FOO: = 11
// GLSL_FOO-NOT: local_size_x = 16
// GLSL_FOO-NOT: = 22

// GLSL_BAR: local_size_x = 16
// GLSL_BAR: = 22
// GLSL_BAR-NOT: local_size_x = 8
// GLSL_BAR-NOT: = 11

// METAL_FOO: void foo(
// METAL_FOO-NOT: void bar(

// METAL_BAR: void bar(
// METAL_BAR-NOT: void foo(

// SPIRV_FOO-DAG: OpExecutionMode %foo LocalSize 8 1 1
// SPIRV_FOO-DAG: %int_11 = OpConstant %int 11
// SPIRV_FOO-NOT: %int_22

// SPIRV_BAR-DAG: OpExecutionMode %bar LocalSize 16 1 1
// SPIRV_BAR-DAG: %int_22 = OpConstant %int 22
// SPIRV_BAR-NOT: %int_11

// WGSL_FOO: @workgroup_size(8, 1, 1)
// WGSL_FOO: fn foo(
// WGSL_FOO-NOT: @workgroup_size(16, 1, 1)
// WGSL_FOO-NOT: fn bar(

// WGSL_BAR: @workgroup_size(16, 1, 1)
// WGSL_BAR: fn bar(
// WGSL_BAR-NOT: @workgroup_size(8, 1, 1)
// WGSL_BAR-NOT: fn foo(
