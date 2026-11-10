//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-a-link-and-entry-point-prep
//META: purpose=Stress: eight RWStructuredBuffer parameters all packed into GlobalParams_0 on CUDA emit because moveEntryPointUniformParamsToGlobalScope is skipped.
//META: intent=stress
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress axis: many global resource parameters. The
// `collectGlobalUniformParameters` pass packs all of them into a
// single `GlobalParams_0` struct rather than emitting them as
// kernel arguments.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWStructuredBuffer<int> a;
RWStructuredBuffer<int> b;
RWStructuredBuffer<int> c;
RWStructuredBuffer<int> d;
RWStructuredBuffer<int> e;
RWStructuredBuffer<int> f;
RWStructuredBuffer<int> g;
RWStructuredBuffer<int> h;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = a[tid.x] + b[tid.x] + c[tid.x] + d[tid.x]
                  + e[tid.x] + f[tid.x] + g[tid.x] + h[tid.x];
}

// CHECK: struct GlobalParams_0
// CHECK: RWStructuredBuffer<int> a_
// CHECK: RWStructuredBuffer<int> h_
// CHECK: extern "C" __global__ void main_{{[0-9]+}}()
