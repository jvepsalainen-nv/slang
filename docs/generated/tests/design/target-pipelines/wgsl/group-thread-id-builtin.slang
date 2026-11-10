//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizeirforwgsl
//META: purpose=SV_GroupThreadID becomes @builtin(local_invocation_id) on the WGSL entry-point parameter
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// legalizeEntryPointVaryingParamsForWGSL maps SV_GroupThreadID to
// the local_invocation_id WGSL builtin.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(8,1,1)]
void main(uint3 ltid : SV_GroupThreadID, uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = ltid.x;
}

// CHECK: @builtin(local_invocation_id)
// CHECK-SAME: vec3<u32>
