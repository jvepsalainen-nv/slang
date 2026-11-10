//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=The HLSL entry point function name is the user's entry-point name; HLSL emit does not rename main.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// HLSL keeps the entry-point name verbatim — unlike SPIR-V's
// OpEntryPoint indirection or Metal's `kernel` qualifier
// reshape, the Slang HLSL backend emits `void main(...)`.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: void main(uint3 tid_{{[0-9]+}} : SV_DispatchThreadID)
