//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#makeexistential
//META: purpose=Assigning a second conforming value into an existing interface-typed variable emits its own makeExistential carrying that value's witness.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on where a `makeExistential` can come from: not only an
// initialisation, but also a later assignment into an already-opened
// existential. `i` is initialised from `A` and then re-assigned from `B` under
// a runtime condition, so no store can be folded away; the CHECKs assert one
// packing inst per assigned value, each pairing its own value with its own
// witness.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };
struct A : IFoo { int run(int x) { return x + 1; } };
struct B : IFoo { int run(int x) { return x + 2; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    A a;
    B b;
    IFoo i = a;
    if (inVal > 0)
    {
        i = b;
    }
    buf[0] = i.run(inVal);
}

// CHECK: let  %{{[0-9]+}} : %IFoo = makeExistential(%a, %{{[0-9]+}})
// CHECK: let  %{{[0-9]+}} : %IFoo = makeExistential(%b, %{{[0-9]+}})
