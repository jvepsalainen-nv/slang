//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=Explicitly specializing a generic with an interface (existential) type argument is rejected with E33180.
//META: intent=characterization
//META: covers=source/slang/slang-ir-specialize.cpp
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterizes the specialization pass: when `specializeGeneric` fails for an
// `IRSpecialize(generic, IFoo)` whose argument is an existential type rather
// than a statically-resolvable concrete type, the pass emits
// CannotSpecializeGenericWithExistential (E33180) and poisons the inst.
// Here `gen<IFoo>(f)` passes the interface `IFoo` itself as the type argument.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target cuda -entry computeMain -stage compute

interface IFoo { int get(); }
struct A : IFoo { int get() { return 1; } }

int gen<T : IFoo>(T v) { return v.get(); }

RWStructuredBuffer<int> outputBuffer;
[numthreads(1, 1, 1)]
void computeMain()
{
    IFoo f = A();
    outputBuffer[0] = gen<IFoo>(f);
}
//CHECK: E33180
//CHECK: specializing 'gen' with an existential type is not allowed
