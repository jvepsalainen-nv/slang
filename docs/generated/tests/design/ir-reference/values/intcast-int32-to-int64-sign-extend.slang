//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: signed widening `int32 -> int64_t` selects the sign-extend variant of `intCast`; lowers to `intCast(%a)` with `Int64` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Signed widening of the same-rank where the existing same-width
// test flipped signedness. Complement to the uint to int64
// counterpart in the existing tests.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int64_t(a);
}

// IR-LABEL: func %main
// IR: intCast(%a)
