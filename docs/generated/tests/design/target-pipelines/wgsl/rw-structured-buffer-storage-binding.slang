//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=RWStructuredBuffer<T> emits as var<storage, read_write> with @binding/@group attributes
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A single RWStructuredBuffer should produce a storage-buffer
// declaration with read_write access and a binding/group pair.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 1.0f;
}

// CHECK: @binding(0) @group(0)
// CHECK-SAME: var<storage, read_write>
// CHECK-SAME: outBuf_{{[0-9]+}}
// CHECK-SAME: array<f32>
