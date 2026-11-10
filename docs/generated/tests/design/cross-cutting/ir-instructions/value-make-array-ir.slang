//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#value-instructions
//META: purpose=An array initializer list lowers to a `makeArray` aggregate-constructor opcode with one operand per element.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's statement that an array initializer list such as
// `int a[3] = { 1, 2, 3 }` lowers to `makeArray`. The elements are
// non-constant `uniform` scalars so the dump keeps the aggregate
// constructor with three operands instead of a folded constant.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform int b;
uniform int c;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int arr[3] = { a, b, c };
    buf[0] = arr[tid.x];
}

// IR-LABEL: func %main
// IR: makeArray(%{{.*}}, %{{.*}}, %{{.*}})
