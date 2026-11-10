//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=[numthreads(1,1,1)] at the lower edge emits @workgroup_size(1, 1, 1)
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower edge of the @workgroup_size axis: the smallest legal
// compute workgroup is (1, 1, 1).

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: @compute
// CHECK: @workgroup_size(1, 1, 1)
