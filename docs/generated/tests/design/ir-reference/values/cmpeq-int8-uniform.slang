//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#comparison
//META: purpose=Expansion: comparing two `int8_t` values lowers to `cmpEQ(%a, %b)` — verifies the opcode is the same shape at the small-int rank.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Smallest-rank integer comparison. The doc admits one `cmpEQ`
// opcode regardless of operand rank.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int8_t a;
uniform int8_t b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(a == b, 1, 0);
}

// IR-LABEL: func %main
// IR: cmpEQ(%a, %b)
