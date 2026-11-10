//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#existential-destructuring
//META: purpose=Dispatching through an interface-typed value produces extractExistentialType(%i) whose result type is Type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the type projection and, specifically, that it yields a *type* as a
// value rather than becoming the concrete type itself. The CHECK reads the
// binding's declared type and asserts it is `Type`, so the recovered concrete
// type is the projection's result, not its annotation.
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

// CHECK: let  %{{[0-9]+}} : Type = extractExistentialType(%i)
