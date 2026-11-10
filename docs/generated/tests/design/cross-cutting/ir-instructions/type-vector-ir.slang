//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#type-instructions
//META: purpose=A vector-typed value uses the `Vec` IR type with element-type and element-count operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `Vec`/`VectorType` row with operands
// `(elementType, elementCount)`. The `uint3` entry-point parameter
// `tid` is typed `Vec(UInt, 3 : Int)` in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWStructuredBuffer<uint> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = tid.x;
}

// IR-LABEL: func %main
// IR: param %tid : Vec(UInt, 3 : Int)
