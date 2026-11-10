//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A read-only StructuredBuffer carries the NonWritable SPIR-V decoration in addition to Block / Binding.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V's NonWritable decoration marks a variable as read-only
// to the shader. Slang applies it to the inputs side of
// StructuredBuffer / ByteAddressBuffer (immutable from the
// shader's POV; writes happen on the host).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

StructuredBuffer<int> inBuf;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf[tid.x] + 1;
}

// CHECK-DAG: OpDecorate %inBuf NonWritable
