//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#type-instructions
//META: purpose=A fixed-size array type uses the `Array` IR type with element-type and element-count operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `Array`/`ArrayType` row ("Fixed-size array;
// hoistable") with operands `(elementType, elementCount)`. A local
// `int[4]` appears as an `Array(Int, 4 : Int)` type in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform int i;
uniform StructuredBuffer<int> in_buf;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int arr[4] = { in_buf[0], in_buf[1], in_buf[2], in_buf[3] };
    buf[0] = arr[i];
}

// IR-LABEL: func %main
// IR: Array(Int, 4 : Int)
