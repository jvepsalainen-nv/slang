//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#type-instructions
//META: purpose=A local array allocation is typed `Ptr(valueType)` and an element address adds the optional access-qualifier and address-space operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `Ptr`/`PtrType` type row and its operand shape
// `valueType, accessQualifierOperand?, addressSpaceOperand?, dataLayout?`.
// A local `int nums[4]` is allocated by `var`, whose result type the IR
// prints as `Ptr(Array(Int, 4 : Int))` — the one-operand form carrying just
// the value type. Taking an element address through `getElementPtr` produces
// the longer form with the optional trailing operands present, so both the
// mandatory and the optional halves of the row are observed in one dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int a;
uniform RWStructuredBuffer<int> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int nums[4];
    for (int i = 0; i < 4; ++i)
        nums[i] = a + i;
    outbuf[0] = nums[2];
}

// IR-LABEL: func %main
// IR: Ptr(Array(Int, 4 : Int)){{.*}}= var
// IR: Ptr(Int, {{.*}}getElementPtr(%{{.*}}, %{{.*}})
