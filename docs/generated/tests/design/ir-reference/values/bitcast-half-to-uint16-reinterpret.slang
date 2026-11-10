//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: reverse 16-bit reinterpret `bit_cast<uint16_t>(half)` lowers to `bitCast(%ha)` with `UInt16` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Reverse of the 16-bit pair: `half` to `uint16_t`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform half ha;
uniform RWStructuredBuffer<uint16_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = bit_cast<uint16_t>(ha);
}

// IR-LABEL: func %main
// IR: bitCast(%ha)
