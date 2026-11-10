//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Explicit vk::binding(15, 3) emits @binding(15) @group(3) preserving high binding/group indices
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// High end of the @binding / @group axis; both indices flow
// through unchanged in the WGSL emit.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

[vk::binding(15, 3)] RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: @binding(15) @group(3)
// CHECK-SAME: var<storage, read_write>
