//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#abort-lowering-processabort--emitabort
//META: purpose=An abort() call declares SPV_KHR_abort and the AbortKHR capability and emits OpAbortKHR with an explicitly-laid-out AbortMessage struct operand.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two-stage abort lowering. The legalizer packs the format string
// into a uint array and builds a nominal AbortMessage struct with explicit
// member offsets, and the emitter then declares the extension and capability
// and emits OpAbortKHR taking that struct as its single operand. The abort is
// guarded by a runtime condition so it is not folded away; CHECK asserts the
// extension, the capability, the laid-out message struct, and the OpAbortKHR
// that consumes it.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x > 100)
        abort("bad value: %u", tid.x);
    outBuf[tid.x] = tid.x;
}

// CHECK-DAG: OpCapability AbortKHR
// CHECK-DAG: OpExtension "SPV_KHR_abort"
// CHECK-DAG: OpMemberDecorate %AbortMessage 0 Offset 0
// CHECK-DAG: OpAbortKHR %AbortMessage
