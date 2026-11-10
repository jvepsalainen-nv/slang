//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: zero-width-change `uint64_t -> int64_t` signedness flip lowers to a single `intCast(%u64a)` with `Int64` result.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Same-width signedness flip at the widest integer rank.
// Counterpart to the existing same-width 32-bit flip; verifies
// `intCast` is the single shape at the 64-bit rank as well.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint64_t u64a;
uniform RWStructuredBuffer<int64_t> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int64_t(u64a);
}

// IR-LABEL: func %main
// IR: intCast(%u64a)
