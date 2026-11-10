//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#var-vs-globalvar-vs-alloca
//META: purpose=A local variable becomes a nullary `var` whose result type is `Ptr<T>`, so member and element access chain off it through address opcodes rather than through the value.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the pointer-typed result of `var`, which is what makes the
// lvalue chain possible. A local struct holding an array is written
// field-by-element and read back, so the local survives lowering (a
// plain scalar local would be collapsed). CHECK asserts the `var` line
// itself is typed `Ptr(%Holder)`, and that the field and element steps
// hanging off it are the address forms `get_field_addr` /
// `getElementPtr` ending in a `load` — the chain only type-checks if
// `var` produced a pointer.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

struct Holder
{
    int arr[4];
}

uniform int a;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main()
{
    Holder h;
    h.arr[1] = a;
    buf[0] = h.arr[1];
}

// IR-LABEL: func %main
// IR: let  %h	: Ptr(%Holder)	= var
// IR: get_field_addr(%h, %arr)
// IR: getElementPtr(
// IR: load(
