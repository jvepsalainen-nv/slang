//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#comparison
//META: purpose=Expansion: comparing two `int64_t` values lowers to `cmpLT(%a, %b)` — the doc places all integer ranks under one opcode.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Widest-rank signed integer comparison.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int64_t a;
uniform int64_t b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(a < b, 1, 0);
}

// IR-LABEL: func %main
// IR: cmpLT(%a, %b)
