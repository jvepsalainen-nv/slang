//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-d-cuda-emit-and-downstream-tools
//META: purpose=With -fp-mode fast, CUDASourceEmitter::emitFrontMatterImpl writes #define SLANG_CUDA_ENABLE_FAST_MATH 1 ahead of the prelude; the default precise mode does not.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The fast-math define gates the prelude's transcendental wrappers,
// so it must be the first non-comment line of the emitted text.

//TEST:SIMPLE(filecheck=FAST):-target cuda -entry main -stage compute -fp-mode fast
//TEST:SIMPLE(filecheck=PRECISE):-target cuda -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = sin(outBuf[tid.x]);
}

// FAST: #define SLANG_CUDA_ENABLE_FAST_MATH 1
// PRECISE-NOT: #define SLANG_CUDA_ENABLE_FAST_MATH 1
