//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: one-rung float widening `half -> float` lowers to a single `floatCast(%ha)` with `Float` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Smallest documented float widening step (half to float).
// Complement to the existing `half -> double` widest-widen test
// to ensure the opcode is the same shape regardless of how many
// precision bits are added.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half ha;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(ha);
}

// IR-LABEL: func %main
// IR: floatCast(%ha)
