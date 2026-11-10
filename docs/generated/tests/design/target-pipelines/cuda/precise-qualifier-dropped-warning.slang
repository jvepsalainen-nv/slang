//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=A precise qualifier on a CUDA temporary is dropped with the PreciseQualifierUnsupportedOnTarget warning (E56005) because CUDA C++ has no precise keyword.
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the CUDA emitter diagnoses rather than silently honours
// `precise`. `emitTempModifiers` in the C++ emitter family (which the
// CUDA emitter inherits) finds the precise decoration on a temporary and
// reports it as unsupported. The CHECK pins the warning code E56005 on
// the declaration that carries the qualifier; the value itself still
// computes, so this is a dropped-qualifier warning and not an error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    precise float t = float(tid.x) * 3.0f + 1.0f;
    //CHECK: E56005
    outBuf[tid.x] = t;
}
