//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=removeTorchKernels runs on the CUDA arm and deletes the host-side [TorchEntryPoint] function, so only the kernel side survives into the emitted CUDA C++.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that on a plain CUDA compile the PyTorch host-side entry
// point is dropped rather than emitted. `[TorchEntryPoint]` normally
// marks a function as an exported host entry point, which would keep it
// alive through linking; the CUDA arm runs `removeTorchKernels`, which
// selects by that decoration and deletes it. The CHECK confirms the
// compute kernel is emitted and CHECK-NOT confirms the torch entry point
// is not present anywhere in the CUDA text.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry computeMain -stage compute

[TorchEntryPoint]
float hostSide(float x)
{
    return x * 2.0f;
}

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = float(tid.x);
}

// CHECK-NOT: hostSide
// CHECK: extern "C" __global__ void computeMain
