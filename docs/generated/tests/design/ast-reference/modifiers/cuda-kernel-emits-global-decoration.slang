//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[CudaKernel]` marks a function as a CUDA kernel; the emitted CUDA carries the `__global__` decoration.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the attribute changes the emitted CUDA function qualifier, which is
// what makes the function launchable from the host. CHECK asserts the emitted
// CUDA declares the function `__global__`; an ordinary Slang function would be
// emitted as a plain device function instead.

//TEST:SIMPLE(filecheck=CHECK): -target cuda -line-directive-mode none

[CudaKernel]
void writeOne(TensorView<float> output)
{
    output.store(cudaThreadIdx().x, 1.0f);
}

//CHECK: __global__ void writeOne
