//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#lowerimmutablebufferloadforcuda
//META: purpose=Direct loads from top-level uniform fields are rooted in CUDA's `__constant__` `SLANG_globalParams` group and remain plain loads rather than `__ldg` global-memory reads.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A top-level uniform is immutable, but CUDA emits its synthesized
// parameter group in `__constant__` memory. `__ldg` lowers to the
// global-memory-only `ld.global.nc`, so this direct field read must
// remain plain.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

uniform uint gValue;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = gValue;
}

// CHECK: struct GlobalParams_0
// CHECK-NOT: __ldg
// CHECK: extern "C" __constant__ GlobalParams_0 SLANG_globalParams;
// CHECK: extern "C" __global__ void main_0()
// CHECK-NOT: __ldg
