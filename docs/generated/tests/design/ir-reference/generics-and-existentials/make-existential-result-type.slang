//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#makeexistential
//META: purpose=The result type of makeExistential is the target interface type, not a wrapper type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies where the packed value's type ends up. The interface local `i` is
// bound directly to the `makeExistential` result, so the CHECK reads the
// binding's declared type and asserts it is `%IFoo` itself — the concrete type
// `%A` has been erased into the operand list rather than showing up in the
// result type.
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

// CHECK: let  %i : %IFoo = makeExistential(
