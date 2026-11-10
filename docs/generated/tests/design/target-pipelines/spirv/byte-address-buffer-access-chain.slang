//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-c-spir-v-legalization-lowering-phi-elimination
//META: purpose=ByteAddressBuffer.Load<T>(offset) lowers via legalizeByteAddressBufferOps (SPIR-V uses translateToStructuredBufferOps=true) into an OpAccessChain through the underlying runtime array.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// For SPIR-V, legalizeByteAddressBufferOps runs with
// scalarizeVectorLoadStore=false and
// translateToStructuredBufferOps=true. The HLSL template
// .Load<T>(offset) is rewritten into structured-buffer-style
// indexing - an OpAccessChain through a runtime array. No
// SPIR-V "Load<T>" template call exists.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

ByteAddressBuffer inBuf;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = inBuf.Load<int>(tid.x * 4);
    outBuf[tid.x] = v;
}

// CHECK: OpAccessChain
