//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#functions-and-generics
//META: purpose=An AccessorDecl lowers to its own func whose Func(...) type takes the containing type as the implicit this parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a property accessor becomes a standalone `func`, which is what
// makes accessors individually addressable as interface requirements later.
// CHECK matches the getter's name hint and requires the next line to be a
// `func` header typed `Func(Int, %Boxed)` — return type first, then the
// implicit `this` parameter.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform int seed;
uniform RWStructuredBuffer<int> buf;

struct Boxed
{
    int v;
    property int doubled { get { return v + v; } }
}

[numthreads(1, 1, 1)]
void main()
{
    Boxed b;
    b.v = seed;
    buf[0] = b.doubled;
}

// CHECK: [nameHint("Boxed.doubled.get")]
// CHECK-NEXT: func %{{[A-Za-z0-9_]+}}	: Func(Int, %Boxed)
