//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: doc_section_digest=e98041c33a94ddbbb2f967b2078765fb561c2b5e826bdd9ca046a44763e172fe
//META: purpose=The `intCast` opcode lowers to `OpSConvert` when widening a signed integer and `OpUConvert` when widening an unsigned integer, realizing the doc's "sign/zero extension chosen by types".
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc describes `intCast` as "Integer-to-integer cast (sign/zero
// extension chosen by types)". The unified IR opcode splits in SPIR-V on
// the source signedness when widening: a signed source emits `OpSConvert`
// (sign-extend), an unsigned source emits `OpUConvert` (zero-extend).
// This pins the distinguishing op per signedness row. Operands are
// uniform narrow ints to keep the conversion live.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -stage compute -entry main

uniform int8_t s8;
uniform uint8_t u8;
uniform RWStructuredBuffer<int> ibuf;
uniform RWStructuredBuffer<uint> ubuf;

[numthreads(1, 1, 1)]
void main()
{
    ibuf[0] = int(s8);
    ubuf[0] = uint(u8);
}

// SPV-DAG: OpSConvert %int %{{[0-9]+}}
// SPV-DAG: OpUConvert %uint %{{[0-9]+}}
