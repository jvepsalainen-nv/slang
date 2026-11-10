//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#makeexistential
//META: purpose=A makeExistential whose payload is a multi-field struct still emits the same two-operand let %i : %IFoo = makeExistential(value, witness) shape.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on payload size: packing does not decompose the value. A three-field
// struct is widened to `IFoo`, and the CHECK asserts the same single
// two-operand inst as the trivial payload case — no per-field packing appears.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };

struct Big : IFoo
{
    int a;
    int b;
    int c;
    int run(int x) { return a + b + c + x; }
};

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    Big big;
    big.a = inVal;
    big.b = inVal + 1;
    big.c = inVal + 2;
    IFoo i = big;
    buf[0] = i.run(inVal);
}

// CHECK: let  %i : %IFoo = makeExistential(%{{[A-Za-z0-9_]+}}, %{{[0-9]+}})
