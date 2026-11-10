//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A renamed entry-point function keeps its symbol (%myKernel) but the OpEntryPoint string operand is the canonical "main" name the driver looks up.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Slang preserves the user's entry-point symbol on the SPIR-V
// function (myKernel) but reports "main" as the
// driver-visible entry-point name string in OpEntryPoint.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry myKernel -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void myKernel(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: OpEntryPoint GLCompute %myKernel "main"
// CHECK: %myKernel = OpFunction %void None
