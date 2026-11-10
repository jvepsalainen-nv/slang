//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=A 0-constraint generic call lowers to specialize(%base, T) without any trailing witness operand.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on the witness half of the argument list: with no conformance
// constraint there is nothing to witness, so the argument list is exactly one
// type. The CHECK closes the `specialize(...)` list right after `Int` and then
// opens the call's own argument list, which fails if a witness operand were
// appended.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

T identity<T>(T x) { return x; }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = identity<int>(a);
}

// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, Int)(%{{[A-Za-z0-9_]+}})
