//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#emitted-spellings
//META: purpose=An int16_t literal emits nothing and reports Int16NotSupportedInWgsl (E56103)
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target wgsl -entry main -stage compute

RWStructuredBuffer<int16_t> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int16_t(7);
}

// CHECK: E56103
