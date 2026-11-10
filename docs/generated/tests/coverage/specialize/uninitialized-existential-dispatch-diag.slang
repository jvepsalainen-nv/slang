//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#dispatchers-and-existential-specialization
//META: purpose=Dynamic dispatch on an interface value left uninitialized on one control-flow path is rejected with E50101.
//META: intent=characterization
//META: covers=source/slang/slang-ir-typeflow-specialize.cpp
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes analyzeExtractExistentialWitnessTable: when the tagged-union
// witness-table set of an interface object contains an uninitialized element
// (one path assigns a conformer, the other leaves it default), a dynamic
// dispatch on it emits DynamicDispatchOnPotentiallyUninitializedExistential
// (E50101). Here `f` is assigned only when `tid.x == 0`; the call `f.get()`
// dispatches dynamically on the possibly-uninitialized object.
// The diagnostic fires twice on this target; non-exhaustive matches the form.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target cuda -entry computeMain -stage compute

interface IFoo { int get(); }
struct A : IFoo { int x; int get() { return x; } }

RWStructuredBuffer<int> outputBuffer;
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    IFoo f;
    if (tid.x == 0) { A a; a.x = 1; f = a; }
    outputBuffer[0] = f.get();
}
//CHECK: E50101
//CHECK: Cannot dynamically dispatch on potentially uninitialized interface object 'IFoo'
