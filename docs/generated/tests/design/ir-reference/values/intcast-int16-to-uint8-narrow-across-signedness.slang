//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `int16_t -> uint8_t` narrowing across signedness lowers to a single `intCast(%i16a)` with `UInt8` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// One-rank narrow combined with a signed-to-unsigned flip from
// the small-int corner of the ladder, complementing the 32-bit
// and 64-bit cases.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int16_t i16a;
uniform RWStructuredBuffer<uint8_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint8_t(i16a);
}

// IR-LABEL: func %main
// IR: intCast(%i16a)
