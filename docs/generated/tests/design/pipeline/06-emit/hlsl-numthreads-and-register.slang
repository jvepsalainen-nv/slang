//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#hlsl
//META: purpose=The HLSL backend emits HLSL source text with an HLSL-shaped entry point (`[numthreads(...)]`) and HLSL `register(uN)` / `register(tN)` resource annotations.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the HLSL backend produces text a DXC/FXC front end would accept.
// A kernel with one read-write and one read-only structured buffer is
// compiled; CHECK asserts the compute entry point carries `[numthreads]` and
// that the two resources land in the `u` and `t` register spaces, which is the
// HLSL-specific spelling of a resource binding.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;
StructuredBuffer<int> inBuf;

[shader("compute")]
[numthreads(16, 2, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf[tid.x] + 1;
}

// HLSL-DAG: RWStructuredBuffer<int {{.*}}> outBuf_{{[0-9]+}} : register(u0)
// HLSL-DAG: {{^}}StructuredBuffer<int {{.*}}> inBuf_{{[0-9]+}} : register(t0)
// HLSL-DAG: {{^}}[numthreads(16, 2, 1)]
// HLSL-DAG: SV_DispatchThreadID
