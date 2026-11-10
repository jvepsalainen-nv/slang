//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=An 8-type-parameter generic call still lowers to specialize(%base, T1..T8) with eight argument operands.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Stresses the variadic argument tail well past the two operands the schema
// names. Eight type parameters must all survive into one argument list; the
// CHECK spells all eight, so a truncated tail fails.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int a;
uniform RWStructuredBuffer<int> buf;

A pickFirst<A, B, C, D, E, F, G, H>(A x1, B x2, C x3, D x4, E x5, F x6, G x7, H x8)
{
    return x1;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = pickFirst<int, int, int, int, int, int, int, int>(a, a, a, a, a, a, a, a);
}

// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, Int, Int, Int, Int, Int, Int, Int, Int)
