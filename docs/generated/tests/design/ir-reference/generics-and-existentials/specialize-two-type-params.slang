//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=A call to a 2-type-param generic produces specialize(%base, T1, T2) — the argument list grows with arity.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on generic arity: with two type parameters the argument tail is two
// entries long and keeps source order. The CHECK pins `Int, Float` in the order
// written at the call site, so a reordering or a collapsed tail would fail.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

A pickFirst<A, B>(A x, B y) { return x; }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = pickFirst<int, float>(a, 1.0f);
}

// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, Int, Float)
