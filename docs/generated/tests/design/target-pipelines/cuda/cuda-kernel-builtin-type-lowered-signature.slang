//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerbuiltintypesforkernelentrypoints-removetorchkernels-handleautobindnames
//META: purpose=lowerBuiltinTypesForKernelEntryPoints rewrites a [CudaKernel] parameter whose type is a Slang builtin aggregate into a CUDA-representable storage struct and calls the generated convertLoweredToOriginal at the top of the kernel body.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies both halves of the pass's contract: the *signature* becomes
// CUDA-clean while the *body* keeps operating on the original type. The
// kernel takes a struct whose first field is a Slang `float3`, which is
// a builtin aggregate. The CHECKs assert the lowered storage struct in
// the kernel parameter list and the generated conversion function being
// invoked in the body — the original type is not deleted, it is
// reconstructed on entry.

//TEST:SIMPLE(filecheck=CHECK):-target cuda

struct MyData
{
    float3 v;
    int n;
};

[CudaKernel]
[shader("compute")]
[numthreads(1, 1, 1)]
void myKernel(uniform MyData d, uniform TensorView<float> output)
{
    uint i = cudaThreadIdx().x;
    output[i] = d.v.x + float(d.n);
}

// The generated conversion function rebuilds the original struct ...
// CHECK: convertLoweredToOriginal
// ... while the kernel signature carries only the lowered storage type.
// CHECK: __global__ void myKernel(U_StructStorage_MyData
// CHECK: = convertLoweredToOriginal
