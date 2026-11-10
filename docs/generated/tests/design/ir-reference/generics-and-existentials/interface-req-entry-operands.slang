//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-tables-and-witness-facts
//META: purpose=An interface requirement lowers to interface_req_entry(requirementKey, requirementFuncType) — first operand is the key, second is the function type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the interface-side half of the dispatch key. The entry names the
// same key a witness row will pair against, and carries the requirement's type
// rather than any implementation; the CHECK pins the key operand followed by
// the start of the `Func(...)` type.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

interface IFoo { int run(int x); };
struct A : IFoo { int run(int x) { return x + 1; } };

uniform int inVal;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    A a;
    buf[0] = a.run(inVal);
}

// CHECK: interface_req_entry(%IFoox5Frun, Func(Int,
