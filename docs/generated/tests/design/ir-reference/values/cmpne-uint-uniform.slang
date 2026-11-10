//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#comparison
//META: purpose=Expansion: comparing two `uint` (unsigned) values via `!=` lowers to `cmpNE(%a, %b)` — same opcode as signed-int and float operands.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Unsigned integer inequality. The doc admits one `cmpNE`
// opcode across signedness; signedness is encoded by operand type
// (which the result type reflects only as `Bool`).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform uint a;
uniform uint b;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = select(a != b, 1, 0);
}

// IR-LABEL: func %main
// IR: cmpNE(%a, %b)
