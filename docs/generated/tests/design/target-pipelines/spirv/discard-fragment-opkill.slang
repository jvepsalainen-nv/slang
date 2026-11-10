//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#spir-v-specific-runtime-predicates
//META: purpose=Under SPIR-V 1.5 (the Slang default) discard lowers to OpKill — the documented "shouldEmitDiscardAsDemote returns false" branch where removeUnreachableCodeAfterDiscardForOpKill is active.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: shouldEmitDiscardAsDemote() runtime predicate. The doc
// states that for SPIR-V < 1.6 (and without
// SPV_EXT_demote_to_helper_invocation) discard lowers to OpKill and
// the removeUnreachableCodeAfterDiscardForOpKill fix-up fires. The
// Slang default is SPIR-V 1.5, so this test pins the OpKill side.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage fragment

RWStructuredBuffer<float4> outBuf;

[shader("fragment")]
float4 main(float4 pos : SV_Position) : SV_Target
{
    if (pos.x > 0.5)
        discard;
    outBuf[0] = pos;
    return float4(1, 0, 0, 1);
}

// CHECK: OpKill
