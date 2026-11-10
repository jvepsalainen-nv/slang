//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#interface-internals
//META: purpose=An interface with no members lowers to an interface opcode with an empty operand list, and a conformance to it to a witness_table with no entries.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Exercises the zero end of the requirement-count axis on both halves of the
// dispatch table. `interface IEmpty {}` has nothing to declare, so the first
// CHECK anchors the end of the line to require `= interface` with no operand
// parentheses; the second requires the conformance table for it to print as a
// childless declaration terminated by `;`.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int seed;
uniform RWStructuredBuffer<int> buf;

interface IEmpty {}

struct Marker : IEmpty {}

int tag<T : IEmpty>(T t, int x) { return x + 1; }

[numthreads(1, 1, 1)]
void main()
{
    Marker m;
    buf[0] = tag(m, seed);
}

// CHECK: let  %IEmpty	: Type	= interface{{$}}
// CHECK: witness_table %{{[0-9]+}}	: witness_table_t(%IEmpty)(%Marker);
