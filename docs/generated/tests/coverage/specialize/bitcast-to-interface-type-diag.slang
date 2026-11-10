//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#type-flow-specialization
//META: purpose=Bit-casting to an interface (existential, non-concrete) target type is rejected with E41204.
//META: intent=characterization
//META: covers=source/slang/slang-ir-typeflow-specialize.cpp
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the BitCast analysis in the typeflow specialization pass: a
// `bit_cast` whose result type is an existential (interface) type cannot be
// resolved to a concrete witness set, so the pass emits
// BitCastToNonConcreteType (E41204). The result type `IFoo` is the existential.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target cuda -entry computeMain -stage compute

interface IFoo { int get(); }

RWStructuredBuffer<int> outputBuffer;
[numthreads(1, 1, 1)]
void computeMain()
{
    int x = 5;
    IFoo f = bit_cast<IFoo>(x);
//CHECK:                   ^ cannot bit-cast to existential (non-concrete) type
    outputBuffer[0] = f.get();
}
