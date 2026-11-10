//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#layout-and-binding
//META: purpose=The user-type-hint pass records each global param's original type name before type lowering erases it, and the SPIR-V backend turns that into an OpDecorateString UserTypeGOOGLE annotation under -fspv-reflect.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the user-facing surface the user-type-hint row names. The
// global parameter's Slang type is erased by resource type lowering long
// before emit, so the only way its original spelling can reach the SPIR-V
// module is the decoration this pass records ahead of that lowering. The
// CHECKs assert the required extension is declared and that the
// decoration carries the source-level type name rather than the lowered
// one.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main -fspv-reflect

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid: SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// SPIRV-DAG: OpExtension "SPV_GOOGLE_user_type"
// SPIRV-DAG: OpDecorateString %outBuf UserTypeGOOGLE "rwstructuredbuffer:<int>"
