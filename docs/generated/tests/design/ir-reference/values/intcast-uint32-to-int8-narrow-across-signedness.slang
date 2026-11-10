//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: `uint32 -> int8_t` narrowing across signedness lowers to a single `intCast(%a)` with `Int8` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Unsigned-to-signed narrow: 32-bit unsigned to 8-bit signed.
// Verifies that lowering keeps this under the same `intCast` shape as the
// signed-narrow and same-rank-flip cases.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform RWStructuredBuffer<int8_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int8_t(a);
}

// IR-LABEL: func %main
// IR: intCast(%a)
