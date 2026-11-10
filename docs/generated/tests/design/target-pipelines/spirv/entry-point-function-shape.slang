//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A compute entry point's function body is wrapped in OpFunction %void None %funcType ... OpReturn OpFunctionEnd.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Every SPIR-V function declaration follows the same
// OpFunction ... OpReturn ... OpFunctionEnd skeleton; an
// entry-point function with void return and no non-builtin
// parameters fits the canonical form.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x == 0)
        return;
    outBuf[tid.x] = 1;
}

// CHECK: %main = OpFunction %void None
// CHECK: OpReturn
// CHECK: OpFunctionEnd
