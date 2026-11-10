//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#legalizeirforwgsl
//META: purpose=SV_DispatchThreadID becomes @builtin(global_invocation_id) on the WGSL entry-point parameter
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// legalizeEntryPointVaryingParamsForWGSL is called from
// legalizeIRForWGSL; SV_DispatchThreadID maps to WGSL's
// global_invocation_id builtin.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// CHECK: fn main
// CHECK-SAME: @builtin(global_invocation_id)
// CHECK-SAME: vec3<u32>
