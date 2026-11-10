//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=A 0-arg `<>` call to a single-type-param generic with no argument-driven inference is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary-negative on generic arity zero: with an empty argument list and no
// call arguments to infer from, the argument tail a `specialize` needs cannot
// be built. The CHECKs pin the could-not-specialize diagnostic at the empty
// bracket pair and the note pointing at the declaration.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target spirv-asm -entry main -stage compute

interface IFoo { int run(int x); };

uniform RWStructuredBuffer<int> buf;

int doStuff<T : IFoo>() { return 0; }
/*CHECK:
    ^^^^^^^ see declaration of func doStuff<T> -> int
*/

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = doStuff<>();
//CHECK:              ^ could not specialize generic for arguments of type ()
}
