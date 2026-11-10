//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A vertex entry point that returns SV_Position emits OpEntryPoint Vertex and lowers the position output to gl_Position with the BuiltIn Position decoration.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: vertex execution model. The varying-output
// legalization rewrites the SV_Position return as a gl_Position
// builtin output, distinct from the compute-stage globals.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage vertex

RWStructuredBuffer<float4> outBuf;

[shader("vertex")]
float4 main(uint vid : SV_VertexID) : SV_Position
{
    outBuf[vid] = float4(0, 0, 0, 1);
    return float4(float(vid), 0, 0, 1);
}

// CHECK: OpEntryPoint Vertex %main
// CHECK: OpDecorate %gl_Position BuiltIn Position
