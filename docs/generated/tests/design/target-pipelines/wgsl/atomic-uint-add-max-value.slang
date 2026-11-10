//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=atomicAdd at uint MAX (0xFFFFFFFFu) emits the value as u32(4294967295) inside the atomicAdd call
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Combined boundary: atomicAdd carries the unsigned MAX literal as
// its 'amount' operand, which the WGSL emitter prints as
// u32(4294967295) inside the atomicAdd argument list.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

RWStructuredBuffer<Atomic<uint>> ctr;
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint old = ctr[0].add(0xFFFFFFFFu);
    outBuf[tid.x] = old;
}

// CHECK: atomicAdd
// CHECK-SAME: u32(4294967295)
