//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#generic
//META: purpose=A generic function lowers to a generic parent opcode containing a func child whose signature is parameterised by the type parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `GenericDecl` becomes a `generic` parent that is shaped like
// a function: it owns a block, and the inner `func` it builds is written in
// terms of the generic's type parameter. CHECK first anchors the `generic`
// header, then requires the inner `func %myGeneric` whose `Func(...)` type
// mentions the type-parameter value rather than a concrete type.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;
uniform int seed;

T myGeneric<T : __BuiltinIntegerType>(T x)
{
    return x + x;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = myGeneric<int>(seed);
}

// CHECK: generic %{{[0-9]+}}	: {{.*}}
// CHECK: func %myGeneric	: Func(%T{{[A-Za-z0-9_]*}}, %T{{[A-Za-z0-9_]*}})
