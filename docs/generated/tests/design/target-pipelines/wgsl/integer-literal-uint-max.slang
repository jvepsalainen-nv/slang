//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=The uint literal 0xFFFFFFFFu emits as u32(4294967295) at the upper edge of the unsigned integer range
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper edge of the uint range; the WGSL emitter writes the
// decimal MAX inside a u32(...) constructor cast.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 0xFFFFFFFFu;
}

// CHECK: u32(4294967295)
