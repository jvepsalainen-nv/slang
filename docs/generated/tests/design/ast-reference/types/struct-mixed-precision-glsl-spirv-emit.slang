//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#declreftype
//META: doc_section_digest=354aa5e4ad824810f192137554fb86892215b9326ffe9fad3435b95088dbb52d
//META: purpose=A struct DeclRefType with mixed-precision fields (half, float, double, int) preserves each field's type through HLSL emission.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the mixed-precision struct-DeclRefType emission claim out to the
// GLSL and SPIR-V text targets the sibling struct-mixed-precision-hlsl-emit.slang
// does not cover. Each scalar field keeps its declared width: GLSL emits
// `float16_t`/`float`/`double`/`int` struct members; SPIR-V declares
// `OpTypeFloat 16`, `OpTypeFloat 32`, `OpTypeFloat 64`, `OpTypeInt 32 1`.
// (Metal and WGSL abort on the `double` member with an internal error;
// see Untested claims + finding types-double-member-metal-wgsl-emit-abort.)
// Each CHECK pins the per-field type token copied verbatim from slangc output.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

struct Mixed {
    half h;
    float f;
    double d;
    int i;
};

//GLSL-DAG: float16_t h_0;
//GLSL-DAG: float f_0;
//GLSL-DAG: double d_0;
//GLSL-DAG: int i_0;
//SPV-DAG: %half = OpTypeFloat 16
//SPV-DAG: %float = OpTypeFloat 32
//SPV-DAG: %double = OpTypeFloat 64
//SPV-DAG: %int = OpTypeInt 32 1
[numthreads(1, 1, 1)]
void main(uniform RWStructuredBuffer<float> outBuf)
{
    Mixed m = { half(1.5), 2.5f, 3.5lf, 4 };
    outBuf[0] = float(m.h) + m.f + float(m.d) + float(m.i);
}
