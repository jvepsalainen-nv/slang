//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=handleAutoBindNames rewrites only the ExternCpp linkage name, which an entry point never reaches, so an [AutoPyBindCUDA] [CudaKernel] function compiled as the selected entry point for -target cuda still emits as extern "C" __global__ void myKernel with no __kernel__ prefix.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented carve-out on the auto-bind rename: the
// pass renames the ExternCpp linkage name to __kernel__<name>, but
// name generation for an entry point resolves through the
// entry-point decoration first and never consults ExternCpp, so the
// rename is invisible in CUDA source text. The test compiles the
// decorated kernel as the entry point and asserts both halves —
// that the unprefixed name is what emits, and that no __kernel__
// prefix appears anywhere in the artifact.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry myKernel -stage compute

RWStructuredBuffer<int> outputBuffer;

[AutoPyBindCUDA]
[CudaKernel]
[shader("compute")]
[numthreads(1, 1, 1)]
void myKernel()
{
    outputBuffer[0] = 3;
}

// CHECK: extern "C" __global__ void myKernel()
// CHECK-NOT: __kernel__
