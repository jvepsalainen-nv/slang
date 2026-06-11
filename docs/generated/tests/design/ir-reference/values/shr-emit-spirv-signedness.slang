//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/values.md#arithmetic-and-bitwise
//META: doc_section_digest=300bbe3c39d84a3dd7997f5a048fb4bd6e896b95057fa5fb8b7116c32840a6b7
//META: purpose=The `shr` opcode lowers to `OpShiftRightArithmetic` for a signed operand and `OpShiftRightLogical` for an unsigned operand, realizing the doc's "arithmetic / logical chosen by operand signedness".
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says `shr` is "Right-shift (arithmetic / logical chosen by
// operand signedness)". The unified IR `shr` opcode (sibling
// arith-shifts.slang pins the IR form) splits in SPIR-V: a signed value
// emits `OpShiftRightArithmetic`, an unsigned value emits
// `OpShiftRightLogical`. GLSL renders both as `>>`, collapsing the
// branch, so spirv-asm is the distinguishing target. Operands are
// uniforms to defeat folding.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

uniform int sa;
uniform uint ua;
uniform int amt;
uniform RWStructuredBuffer<int> ibuf;
uniform RWStructuredBuffer<uint> ubuf;

[numthreads(1, 1, 1)]
void main()
{
    ibuf[0] = sa >> amt;
    ubuf[0] = ua >> amt;
}

// SPV-DAG: OpShiftRightArithmetic %int %{{[0-9]+}} %{{[0-9]+}}
// SPV-DAG: OpShiftRightLogical %uint %{{[0-9]+}} %{{[0-9]+}}
