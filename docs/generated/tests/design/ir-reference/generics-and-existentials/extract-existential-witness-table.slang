//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#existential-destructuring
//META: purpose=Dispatching through an interface-typed value produces extractExistentialWitnessTable(%i) whose result type is witness_table_t(%I).
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the witness projection: the conformance recovered from an
// existential is typed by the interface it witnesses, which is what the
// downstream lookup needs. The CHECK reads the binding's declared type and
// asserts `witness_table_t(%IFoo)`.
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

// CHECK: let  %{{[0-9]+}} : witness_table_t(%IFoo) = extractExistentialWitnessTable(%i)
