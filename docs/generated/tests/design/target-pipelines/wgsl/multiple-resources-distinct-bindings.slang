//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Multiple resources at module scope receive distinct sequential @binding indices in @group(0)
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Three resources should receive three distinct @binding indices
// sharing the same @group.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<float> outBuf;
StructuredBuffer<float> a;
StructuredBuffer<float> b;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = a[tid.x] + b[tid.x];
}

// CHECK: @binding(0) @group(0)
// CHECK: @binding(1) @group(0)
// CHECK: @binding(2) @group(0)
