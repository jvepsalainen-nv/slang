//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `int64_t -> uint16_t` narrowing across signedness lowers to a single `intCast(%i64a)` with `UInt16` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Combines a 48-bit width drop with a signed-to-unsigned flip.
// Verifies that lowering keeps both steps under one `intCast` opcode keyed by
// the result type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t i64a;
uniform RWStructuredBuffer<uint16_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = uint16_t(i64a);
}

// IR-LABEL: func %main
// IR: intCast(%i64a)
