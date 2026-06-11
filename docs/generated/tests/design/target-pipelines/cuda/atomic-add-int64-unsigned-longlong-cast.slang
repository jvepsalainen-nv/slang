//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T12:30:00+00:00
//META: source_commit=728d25945b51e344d24caed66dc50e1d1bd039fa
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-c-cuda-legalization-lowering-phi-elimination
//META: doc_section_digest=2314d32203f54be9e61ab85654673e194c467242384d7feb583ce0587536f9da
//META: purpose=A 64-bit InterlockedAdd lowers to atomicAdd with an (unsigned long long*) pointer cast on the destination because CUDA only provides the unsigned-64 atomicAdd overload.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The AtomicAdd emitter branch takes an extra path for an int64 data type:
// it casts the destination pointer to `(unsigned long long*)` so the call
// binds the only CUDA atomicAdd 64-bit overload. This is a width-driven
// sub-branch the 32-bit add test does not exercise. CHECK pins the
// `(unsigned long long*)` cast inside the atomicAdd call.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int64_t> outBuf;

[shader("compute")]
[numthreads(8, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    InterlockedAdd(outBuf[0], int64_t(tid.x));
}

// CHECK: atomicAdd((unsigned long long*)
