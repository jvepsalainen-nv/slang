//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Read-only StructuredBuffer<T> emits as var<storage, read> (read-only access mode)
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// StructuredBuffer<T> is read-only so the storage access qualifier
// should be 'read', not 'read_write'.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

StructuredBuffer<float> inBuf;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf[tid.x];
}

// CHECK: var<storage, read>
// CHECK-SAME: inBuf_{{[0-9]+}}
