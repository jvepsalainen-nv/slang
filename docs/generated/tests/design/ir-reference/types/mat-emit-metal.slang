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

// Verifies the Metal spelling of the float4x4 Mat, the target the sibling
// mat-emit-multi-target.slang declined to check (it asserted Metal had "no
// portable single-token spelling"). Metal in fact emits the in-register
// matrix as matrix<float,int(4),int(4)> for the multiply, and stores the
// uniform via a _MatrixStorage_float4x4 wrapper struct. CHECK pins both the
// storage-struct name and the matrix<float,...> value spelling.

//TEST:SIMPLE(filecheck=CHECKMETAL):-target metal -stage compute -entry main

uniform float4x4 m;
uniform float4 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (mul(m, v)).x;
}

// CHECKMETAL-DAG: struct _MatrixStorage_float4x4
// CHECKMETAL-DAG: matrix<float,int(4),int(4)>
