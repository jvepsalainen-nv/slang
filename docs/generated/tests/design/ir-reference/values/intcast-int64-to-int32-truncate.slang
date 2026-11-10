//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#conversions
//META: purpose=Expansion: signed 64-to-32 truncation lowers to a single `intCast(%i64a)` with `Int` result — the reverse direction of the sign-extend widening case.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Top-of-rank truncation: 64-bit signed to 32-bit signed. The
// doc places this under the same `intCast` opcode as widening.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t i64a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = int(i64a);
}

// IR-LABEL: func %main
// IR: intCast(%i64a)
