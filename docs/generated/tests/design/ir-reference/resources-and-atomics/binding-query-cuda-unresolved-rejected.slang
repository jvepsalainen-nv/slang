//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#resource-queries-and-modifiers
//META: purpose=On `-target cuda` the register queries cannot resolve a register and space and fail with `E81111` instead of returning a fallback value.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc states that targets that cannot resolve a register and space,
// such as CUDA, reject the query with E81111.

//TEST:SIMPLE(filecheck=DIAG,exit-code=-1):-target cuda -stage compute -entry main

RWStructuredBuffer<uint> outBuf;
SamplerState samp;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = __getRegisterIndex(samp);
}

// DIAG: E81111
