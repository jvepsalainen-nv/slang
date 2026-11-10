//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Explicit vk::binding(0, 0) emits @binding(0) @group(0) at the lower edge of the binding axis
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower edge of the @binding / @group axis; explicit (0, 0) maps
// directly through to the WGSL annotation.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

[vk::binding(0, 0)] RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: @binding(0) @group(0)
// CHECK-SAME: var<storage, read_write>
// CHECK-SAME: outBuf_{{[0-9]+}}
