//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-equality-constraint-for-associated-type
//META: purpose=A call violating an associated-type equality constraint (`where T.PropertyType == int` applied to a conformer whose PropertyType is float) is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the commented-out negative case in the doc's "Type equality
// constraint for associated type" example: `addTwoInts<T:IFace> where
// T.PropertyType == int` requires the associated type be int, but FloatProperty
// has PropertyType == float. Calling addTwoInts with FloatProperty values
// cannot satisfy the equality constraint; CHECK asserts E30440 "generic
// constraint not satisfied" fires, naming the 'T.PropertyType == int'
// constraint (non-exhaustive skips the constraint/function declaration notes).

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

interface IFace
{
    associatedtype PropertyType;
    property prop : PropertyType;
}

struct FloatProperty : IFace
{
    typealias PropertyType = float;
    PropertyType prop;
}

int addTwoInts<T : IFace>(T a, T b) where T.PropertyType == int
{
    return a.prop + b.prop;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    FloatProperty f1 = { 1.0 };
    FloatProperty f2 = { 2.0 };
    outputBuffer[0] = addTwoInts(f1, f2);
//CHECK:                        ^ could not satisfy the generic constraint 'T.PropertyType == int'
    //CHECK: E30440
}
