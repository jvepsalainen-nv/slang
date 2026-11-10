//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=[numthreads(8,8,4)] (a 3D 256-product) emits @workgroup_size(8, 8, 4) preserving each axis
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A 3-D shape that multiplies to 256 exercises that each axis is
// kept independent in the emitted @workgroup_size attribute.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8,8,4)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: @workgroup_size(8, 8, 4)
