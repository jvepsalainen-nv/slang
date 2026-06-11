//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T12:29:46+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/types.md#vec-and-mat
//META: doc_section_digest=3375fc96f25274ba6b5f61268aab7b799044240063cd3b64ac3928c13a5702fc
//META: purpose=Per-shape Mat emission: a floatRxC lowers to the row/column-specific matrix spelling on the shared SPIR-V/GLSL legalize path.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-shape branch of Mat emission for the 4x2 shape.
// The doc names Mat(elementType, rowCount, columnCount, layout) generically;
// this pins the 4x2 cell of that shape family on the shared SPIR-V/GLSL
// legalize path. The matrix is a uniform read into a buffer so it escapes DCE.
// CHECKSPV pins the OpTypeMatrix declaration (column vector x row count that
// encodes the 4x2 shape); CHECKGLSL pins mat4x2, the GLSL spelling.

//TEST:SIMPLE(filecheck=CHECKSPV):-target spirv-asm -stage compute -entry main
//TEST:SIMPLE(filecheck=CHECKGLSL):-target glsl -stage compute -entry main

uniform float4x2 m;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = m[0][0];
}

// CHECKSPV: %mat4v2float = OpTypeMatrix %v2float 4
// CHECKGLSL: mat4x2
