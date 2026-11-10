//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#how-the-passes-are-ordered
//META: purpose=SPIR-V legalization is a direct call rather than a SLANG_PASS, so no BEFORE legalizeSPIRV / AFTER legalizeSPIRV header appears in -dump-ir output even though the stage certainly ran.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out the ordering section makes for SPIR-V: `-dump-ir`
// shows exactly the `SLANG_PASS` call sites of `linkAndOptimizeIR`, and
// the SPIR-V legalization is invoked outside that wrapper by the emit
// backend. The positive CHECK confirms the dump stream really is present
// and populated for this compile (so the CHECK-NOTs are not vacuous), and
// the CHECK-NOTs assert neither legalization stage ever names a header —
// which is what tells a reader not to go looking for one.

//TEST:SIMPLE(filecheck=DUMP):-target spirv-asm -dump-ir -o - -stage compute -entry main

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid: SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// The dump stream exists and carries wrapped passes ...
// DUMP: ### AFTER
// ... but never the two stages that run outside the wrapper.
// DUMP-NOT: legalizeSPIRV
// DUMP-NOT: simplifyIRForSpirvLegalization
