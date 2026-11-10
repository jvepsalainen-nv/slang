//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/structure.md#struct-internals
//META: purpose=A class declaration lowers to a class parent opcode, a distinct spelling from struct, owning the same field children.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the container role is shared but the opcode spelling is not:
// the class-vs-struct distinction survives lowering. CHECK requires the header
// to read `class %Counter : Type` (not `struct`) while the child row is the
// same `field(key, type)` form a struct uses.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform RWStructuredBuffer<int> buf;
uniform int seed;

class Counter
{
    int n;
}

[numthreads(1, 1, 1)]
void main()
{
    Counter c = new Counter();
    c.n = seed;
    buf[0] = c.n;
}

// CHECK: class %Counter	: Type
// CHECK: field(%n, Int)
