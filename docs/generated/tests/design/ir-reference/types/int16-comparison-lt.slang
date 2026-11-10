//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#basic-scalar-types
//META: purpose=Expansion: less-than compare on Int16 operands yields a Bool-typed cmpLT preserving the narrow operand type.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// less-than compare on Int16 operands yields a Bool-typed cmpLT
// preserving the narrow operand type. Comparing two `int16_t` globals
// produces a `cmpLT` instruction with `Int16` operands, illustrating
// that the narrow type survives to the comparison opcode.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int16_t a;
uniform int16_t b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = (a < b) ? 1 : 0;
}

// IR: {{.*}}: Bool{{.*}}= cmpLT(%a, %b)
