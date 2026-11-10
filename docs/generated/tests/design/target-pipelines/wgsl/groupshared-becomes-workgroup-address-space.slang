//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#specializeaddressspaceforwgsl
//META: purpose=groupshared declarations are tagged var<workgroup> by specializeAddressSpaceForWGSL
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A 'groupshared' array maps to WGSL's workgroup address space.
// This is decided by specializeAddressSpaceForWGSL.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;
groupshared int sharedArr[64];

[shader("compute")]
[numthreads(64,1,1)]
void main(uint3 tid : SV_DispatchThreadID, uint3 ltid : SV_GroupThreadID)
{
    sharedArr[ltid.x] = int(tid.x);
    outBuf[tid.x] = sharedArr[ltid.x];
}

// CHECK: var<workgroup>
// CHECK-SAME: sharedArr_{{[0-9]+}}
// CHECK-SAME: array<i32
