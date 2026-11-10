//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-a-link-and-entry-point-prep
//META: purpose=Global uniform parameters are gathered into a GlobalParams_0 struct bound to __constant__ memory because moveEntryPointUniformParamsToGlobalScope is skipped for CUDA.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `collectGlobalUniformParameters` (always-on in Phase A, plus the CUDA
// `collectOptiXEntryPointUniformParams`-instead-of-`collectEntryPointUniformParams`
// substitution) packs module-scope uniforms into a single struct.
// The CUDA emitter places that struct in `__constant__` memory.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> outBuf;
StructuredBuffer<float> roBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(roBuf[tid.x]);
}

// CHECK: struct GlobalParams_0
// CHECK: extern "C" __constant__ GlobalParams_0 SLANG_globalParams
