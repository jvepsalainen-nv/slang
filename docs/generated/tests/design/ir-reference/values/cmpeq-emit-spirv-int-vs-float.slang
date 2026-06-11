//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/values.md#comparison
//META: doc_section_digest=03e312fcc9f534bb1522ca14baac23dce5576764a035ba6d311c03be3b39ed14
//META: purpose=The `cmpEQ` opcode lowers to `OpIEqual` for integer operands (signed and unsigned collapse to the same op) and `OpFOrdEqual` for floating-point operands.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Equality differs from the ordered relationals: the signed and unsigned
// integer rows collapse to a single signedness-agnostic `OpIEqual`
// (verified by compiling both and diffing — `int` and `uint` emit the
// identical op), while the float row uses `OpFOrdEqual`. This pins the
// two surviving distinct cells and documents the int/uint collapse.
// Operands are uniforms; `select` keeps the bool result live.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

uniform int sa;
uniform int sb;
uniform uint ua;
uniform uint ub;
uniform float fa;
uniform float fb;
uniform RWStructuredBuffer<int> ibuf;

[numthreads(1, 1, 1)]
void main()
{
    ibuf[0] = select(sa == sb, 1, 0);
    ibuf[1] = select(ua == ub, 1, 0);
    ibuf[2] = select(fa == fb, 1, 0);
}

// SPV-DAG: OpIEqual %bool %{{[0-9]+}} %{{[0-9]+}}
// SPV-DAG: OpFOrdEqual %bool %{{[0-9]+}} %{{[0-9]+}}
