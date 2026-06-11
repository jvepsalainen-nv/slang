//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:31:20+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: doc_section_digest=3375fc96f25274ba6b5f61268aab7b799044240063cd3b64ac3928c13a5702fc
//META: purpose=A float4x4 matrix type lowers to target-specific spellings (float4x4 on HLSL, mat4x4 on GLSL, mat4x4<f32> on WGSL).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the SPIR-V spelling of the float4x4 Mat, a target the sibling
// mat-emit-multi-target.slang did not cover. The matrix multiplies a vector
// whose result escapes into a buffer so the type survives to emit; CHECK
// pins OpTypeMatrix %v4float 4 (built on OpTypeVector %float 4), the
// SPIR-V composite-type spelling that identifies the 4x4 float matrix.

//TEST:SIMPLE(filecheck=CHECKSPV):-target spirv-asm -stage compute -entry main

uniform float4x4 m;
uniform float4 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (mul(m, v)).x;
}

// CHECKSPV-DAG: %v4float = OpTypeVector %float 4
// CHECKSPV-DAG: %mat4v4float = OpTypeMatrix %v4float 4
