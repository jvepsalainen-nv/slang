//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: unsigned `uint -> float` lowers to `castIntToFloat(%a)` with `Float` result — same opcode as the signed case, signedness encoded by operand type.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Unsigned-to-float complement to the signed case. The doc
// admits one opcode `castIntToFloat`; the operand type carries
// the signedness.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = float(a);
}

// IR-LABEL: func %main
// IR: castIntToFloat(%a)
