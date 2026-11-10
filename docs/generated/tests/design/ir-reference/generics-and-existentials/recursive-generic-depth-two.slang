//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#generic-application
//META: purpose=Doubly-nested instantiation Box<Box<int>> lowers to a nested specialize(%Box, specialize(%Box, Int)) type-level value.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Boundary on argument *composition*: a generic argument may itself be a
// `specialize` result, because the opcode is a value like any other. The CHECK
// pins one `specialize` textually inside another's argument list.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

struct Box<T> { T val; };

uniform RWStructuredBuffer<int> buf;
uniform int a;

[numthreads(1, 1, 1)]
void main()
{
    Box<Box<int>> nested;
    nested.val.val = a;
    buf[0] = nested.val.val;
}

// CHECK: specialize(%{{[0-9]+}}, specialize(%{{[0-9]+}}, Int))
