//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#lookupwitness--lookupwitnessmethod
//META: purpose=Two distinct interface methods called on the same generic-constrained value produce two lookupWitness sites keyed by different requirement keys.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on the key operand: the same witness table serves several
// requirements, so what distinguishes two dispatches is the key, not the
// table. The CHECKs pin two lookups differing only in their second operand.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IMulti
{
    int methA(int x);
    int methB(int x);
};

struct S : IMulti
{
    int methA(int x) { return x; }
    int methB(int x) { return x + 1; }
};

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int helper<T : IMulti>(T t, int x) { return t.methA(x) + t.methB(x); }

[numthreads(1, 1, 1)]
void main()
{
    S s;
    buf[0] = helper<S>(s, inVal);
}

// CHECK: lookupWitness(%{{[0-9]+}}, %IMultix5FmethA)
// CHECK: lookupWitness(%{{[0-9]+}}, %IMultix5FmethB)
