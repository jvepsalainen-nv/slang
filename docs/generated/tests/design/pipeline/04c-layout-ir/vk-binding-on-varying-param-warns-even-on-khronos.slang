//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#explicit-vkbinding-on-entry-point-parameters
//META: purpose=Even on a target that honors the attribute, a vk::binding placed on a parameter type that consumes no descriptor-shaped resource is reported as ignored.
//META: intent=boundary
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the type side of the gate rather than the target side. The
// annotation sits on a plain varying `SV_DispatchThreadID` parameter, which
// consumes no descriptor slot, so even on SPIR-V - a target that does honor
// the attribute on resource parameters - it must still be reported as
// ignored. The caret annotation pins E38010 to the varying parameter.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target spirv-asm -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main([[vk::binding(3, 1)]] uint3 tid : SV_DispatchThreadID, uniform RWStructuredBuffer<int> outBuf)
//CHECK:                              ^^^ modifier on entry point parameter is unsupported
//CHECK:                              ^^^ attribute '[[vk::binding(...)]]' on parameter 'tid' is unsupported on entry point parameters and will be ignored
{
    outBuf[0] = int(tid.x);
}
