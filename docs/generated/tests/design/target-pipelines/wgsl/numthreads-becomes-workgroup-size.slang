//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=[numthreads(X,Y,Z)] on a compute entry point emits @compute followed by @workgroup_size(X, Y, Z)
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A compute entry point with [numthreads(8,4,2)] is expected to
// emit as @compute / @workgroup_size(8, 4, 2) on the function in
// the WGSL output.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8,4,2)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: @compute
// CHECK: @workgroup_size(8, 4, 2)
// CHECK: fn main
