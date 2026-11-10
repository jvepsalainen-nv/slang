//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A compute entry point emits OpEntryPoint GLCompute %func "main" with the GLCompute execution model.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The OpEntryPoint instruction names the execution model
// ("GLCompute" for a compute shader), the SPIR-V function symbol,
// the user-visible entry-point name string ("main"), and the
// referenced interface variables.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = int(tid.y);
}

// CHECK: OpEntryPoint GLCompute %{{[a-zA-Z_0-9]+}} "main"
