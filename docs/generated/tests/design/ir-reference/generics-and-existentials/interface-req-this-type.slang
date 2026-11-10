//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#witness-tables-and-witness-facts
//META: purpose=The function type carried in an interface_req_entry uses this_type(%I) for the receiver parameter.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies that the requirement's type stays abstract in its receiver
// position: the interface declares a requirement about whatever type conforms,
// so the receiver is `this_type(%IFoo)` rather than any concrete struct. The
// CHECK asserts that spelling inside the entry's type operand.
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

// CHECK: interface_req_entry({{.*}}this_type(%IFoo)
