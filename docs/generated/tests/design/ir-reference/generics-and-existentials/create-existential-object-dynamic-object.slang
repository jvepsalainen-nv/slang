//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#existential-construction
//META: purpose=The core-module createDynamicObject builds an existential from a runtime type id, lowering to createExistentialObject(typeID, value).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the runtime-tagged construction form, which pairs a type id with a
// value instead of a static witness. `createDynamicObject<IFoo, A>` is the
// Slang surface declared with that intrinsic op; `-conformance` supplies the
// sequential id the target needs. The CHECK pins the resulting inst with the
// literal id first and the packed value second.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute -conformance A:IFoo=0

interface IFoo { int run(int x); };
struct A : IFoo { int v; int run(int x) { return v + x; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    A a;
    a.v = inVal;
    IFoo i = createDynamicObject<IFoo, A>(0, a);
    buf[0] = i.run(inVal);
}

// CHECK: let  %i : %IFoo = createExistentialObject(0 : UInt, %{{[0-9]+}})
