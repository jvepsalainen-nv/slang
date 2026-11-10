//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#collectoptixentrypointuniformparams
//META: purpose=collectOptiXEntryPointUniformParams replaces collectEntryPointUniformParams for raygeneration entry points so a CUDA raygeneration shader emits as an extern "C" __global__ void __raygen__<name> kernel through the OptiX SBT pathway.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `## collectOptiXEntryPointUniformParams`: this CUDA-only Phase A
// pass handles SBT-bound uniform params for OptiX entry-point
// shapes, replacing the `collectEntryPointUniformParams` that the
// other shader targets run. The user-visible consequence is that
// a `[shader("raygeneration")]` kernel survives the pipeline and
// is wrapped by the CUDA emitter with the OptiX-style symbol
// prefix `__raygen__` (see `slang-emit-cuda.cpp` line ~494).

//TEST:SIMPLE(filecheck=CHECK):-target cuda -stage raygeneration -entry rayGenMain

uniform RWStructuredBuffer<float4> g_output;

[shader("raygeneration")]
void rayGenMain()
{
    uint2 idx = DispatchRaysIndex().xy;
    g_output[idx.x] = float4(float(idx.x), float(idx.y), 0.0, 1.0);
}

// CHECK: extern "C" __global__ void __raygen__rayGenMain
