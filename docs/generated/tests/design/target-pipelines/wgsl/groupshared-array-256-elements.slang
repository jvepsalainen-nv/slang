//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#specializeaddressspaceforwgsl
//META: purpose=A 256-element groupshared array emits as var<workgroup> ... : array<u32, i32(256)>
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper edge of the groupshared array axis (matching the 256
// workgroup max). The element count appears literally inside
// array<T, N> in the WGSL emit.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;
groupshared uint sharedArr[256];

[shader("compute")]
[numthreads(256,1,1)]
void main(uint3 tid : SV_DispatchThreadID, uint3 ltid : SV_GroupThreadID)
{
    sharedArr[ltid.x] = tid.x;
    outBuf[tid.x] = sharedArr[ltid.x];
}

// CHECK: var<workgroup>
// CHECK-SAME: sharedArr_{{[0-9]+}}
// CHECK-SAME: array<u32
// CHECK-SAME: 256
