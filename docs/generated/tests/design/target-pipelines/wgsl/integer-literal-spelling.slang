//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=Slang integer constants emit as i32(N) / u32(N) constructor-style spellings in WGSL
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// WGSL emits literal integers via constructor-style casts; an
// 'int' value uses i32(N), a 'uint' value uses u32(N).

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;
RWStructuredBuffer<uint> outUBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 42;
    outUBuf[tid.x] = 7u;
}

// CHECK: i32(42)
// CHECK: u32(7)
