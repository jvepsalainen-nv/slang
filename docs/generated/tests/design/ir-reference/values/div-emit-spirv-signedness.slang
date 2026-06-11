//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: doc_section_digest=300bbe3c39d84a3dd7997f5a048fb4bd6e896b95057fa5fb8b7116c32840a6b7
//META: purpose=The unified `div` IR opcode lowers to three distinct SPIR-V ops keyed by operand type: `OpSDiv` for signed, `OpUDiv` for unsigned, `OpFDiv` for floating-point.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc states `div` is "Division (signed / unsigned / floating-point
// keyed by operand types)". The IR opcode is one (`div`); the SPIR-V
// legalizer branches it into three distinct ops. This pins the
// distinguishing emitted token per operand-type row of that branch.
// Operands come from uniforms so the constant folder cannot collapse the
// division. GLSL collapses all three rows to the `/` operator, so the
// distinguishing target for this per-type branch is spirv-asm.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

uniform int sa;
uniform int sb;
uniform uint ua;
uniform uint ub;
uniform float fa;
uniform float fb;
uniform RWStructuredBuffer<int> ibuf;
uniform RWStructuredBuffer<uint> ubuf;
uniform RWStructuredBuffer<float> fbuf;

[numthreads(1, 1, 1)]
void main()
{
    ibuf[0] = sa / sb;
    ubuf[0] = ua / ub;
    fbuf[0] = fa / fb;
}

// SPV-DAG: OpSDiv %int %{{[0-9]+}} %{{[0-9]+}}
// SPV-DAG: OpUDiv %uint %{{[0-9]+}} %{{[0-9]+}}
// SPV-DAG: OpFDiv %float %{{[0-9]+}} %{{[0-9]+}}
