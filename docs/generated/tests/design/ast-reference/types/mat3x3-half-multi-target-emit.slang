//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: doc_section_digest=d7566fda8bc9eff74409576c78889c2b13b22cd59e2676d755123b9475f668d4
//META: purpose=MatrixExpressionType<half, 3, 3> survives type-checking and lowers to a half matrix type on the HLSL backend.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the half 3x3 MatrixExpressionType emission claim out to the four
// non-HLSL shader text targets the sibling mat3x3-half-hlsl-emit.slang
// does not cover. The half matrix lowers to a target-specific 16-bit
// float matrix form: GLSL `f16mat3x3`, Metal `matrix<half,int(3),int(3)>`,
// SPIR-V the Float16 capability + `OpTypeFloat 16`, WGSL `mat3x3<f16>`.
// Each CHECK pins the token that identifies the half element type on
// that target (copied verbatim from slangc output).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=METAL):-target metal -stage compute -entry main
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry main

//GLSL: f16mat3x3
//METAL: matrix<half,int(3),int(3)>
//SPV: %half = OpTypeFloat 16
//WGSL: mat3x3<f16>
[numthreads(1, 1, 1)]
void main(uniform RWStructuredBuffer<float> outBuf)
{
    matrix<half, 3, 3> m = matrix<half, 3, 3>(
        half(1), half(0), half(0),
        half(0), half(2), half(0),
        half(0), half(0), half(3));
    outBuf[0] = float(m[0][0]) + float(m[1][1]) + float(m[2][2]);
}
