//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#existential-destructuring
//META: purpose=Interface dispatch through an existential follows the sequence extractExistentialType, extractExistentialValue, extractExistentialWitnessTable, lookupWitness, call.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies that the three projections and the lookup compose into one dispatch
// idiom rather than appearing independently. A single method call through an
// interface-typed local is made, and the ordered CHECKs assert all five insts
// appear in the order the dispatch needs them: recover the type, recover the
// value, recover the witness, resolve the requirement, call it.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };
struct A : IFoo { int run(int x) { return x + 1; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    A a;
    IFoo i = a;
    buf[0] = i.run(inVal);
}

// CHECK: extractExistentialType(%i)
// CHECK: extractExistentialValue(%i)
// CHECK: extractExistentialWitnessTable(%i)
// CHECK: lookupWitness(
// CHECK: call %{{[0-9]+}}(
