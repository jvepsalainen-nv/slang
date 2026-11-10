//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#specialize
//META: purpose=A generic taking an interface-typed parameter composes a specialize call site with a makeExistential argument.
//META: intent=stress
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Stresses generic application and existential construction meeting at one
// call site: the argument is widened to `IFoo` by `makeExistential` while the
// callee is built by `specialize`. The CHECKs assert both opcodes appear, in
// the order the argument is prepared before the call.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };
struct A : IFoo { int run(int x) { return x + 1; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

int processExistential<T : IFoo>(IFoo i, int x) { return i.run(x); }

[numthreads(1, 1, 1)]
void main()
{
    A a;
    buf[0] = processExistential<A>(a, inVal);
}

// CHECK: makeExistential(%{{[A-Za-z0-9_]+}}, %{{[0-9]+}})
// CHECK: call specialize(%{{[A-Za-z0-9_]+}}, %A, %{{[0-9]+}})
