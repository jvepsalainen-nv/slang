//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=[numthreads(256,1,1)] at the WebGPU compute upper edge emits @workgroup_size(256, 1, 1) verbatim
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper edge of WebGPU's per-axis compute workgroup_size. Slang
// passes the literal through unchanged; Tint enforces the limit
// downstream.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(256,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: @compute
// CHECK: @workgroup_size(256, 1, 1)
