//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#adjacent-targets
//META: purpose=CUDA/OptiX supports the ray-object accessors in the intersection stage, so ObjectRayOrigin in an intersection entry point emits as optixGetObjectRayOrigin inside an __intersection__ kernel.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the positive half of the CUDA/OptiX stage-coverage claim:
// `intersection` is one of the two stages where the ray-object accessors
// are available on this target family. OptiX has no CodeGenTarget of its
// own, so the shader is compiled with `-target cuda` and selected purely
// by stage. The CHECKs assert the OptiX kernel-symbol prefix for the
// stage and the intrinsic the accessor lowers to.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry isectMain -stage intersection

RWStructuredBuffer<float> outBuf;

[shader("intersection")]
void isectMain()
{
    float3 o = ObjectRayOrigin();
    outBuf[0] = o.x;
}

// CHECK: extern "C" __global__ void __intersection__isectMain
// CHECK: optixGetObjectRayOrigin()
