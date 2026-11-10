//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/ir-instructions.md#type-instructions
//META: purpose=A matrix-typed value uses the `Mat` IR type with element-type, row-count, column-count and layout operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's `Mat`/`MatrixType` row with operands
// `(elementType, rowCount, columnCount, layout)`. A `float4x4` value
// read from a buffer appears as a `Mat(Float, 4 : Int, 4 : Int, ...)`
// type in the IR dump.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform StructuredBuffer<float4x4> in_buf;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float4x4 m = in_buf[0];
    buf[0] = m[0][0];
}

// IR-LABEL: func %main
// IR: Mat(Float, 4 : Int, 4 : Int
