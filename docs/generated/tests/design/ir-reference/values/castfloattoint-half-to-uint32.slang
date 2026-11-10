//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `half -> uint` truncation lowers to a single `castFloatToInt(%ha)` with `UInt` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Smallest-rank float to mid-rank unsigned int. Verifies that lowering keeps
// it under one opcode keyed by operand and result type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half ha;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(ha);
}

// IR-LABEL: func %main
// IR: castFloatToInt(%ha)
