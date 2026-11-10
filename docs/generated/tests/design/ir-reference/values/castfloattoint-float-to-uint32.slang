//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `float -> uint` truncation (signed-to-unsigned float-to-int) lowers to a single `castFloatToInt(%fa)` with `UInt` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Float-to-unsigned variant. The doc admits one opcode for both
// signed and unsigned destinations; the result type encodes the
// signedness.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float fa;
uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint(fa);
}

// IR-LABEL: func %main
// IR: castFloatToInt(%fa)
