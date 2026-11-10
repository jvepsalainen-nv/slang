//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/targets.md#definition-forms
//META: purpose=An extension atom records its version floor through inheritance, so asking for `SPV_KHR_cooperative_matrix` transitively raises the effective SPIR-V version to its `_spirv_1_6` floor.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that inheritance in a capability declaration is what
// carries an extension's version floor, rather than the floor being
// asserted at the use site. `SPV_KHR_cooperative_matrix` inherits a
// SPIR-V 1.6 floor; the kernel itself uses nothing that needs it. The
// CHECK asserts the emitted module header moved up to 1.6, which can
// only come from folding in the inherited atom.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -capability SPV_KHR_cooperative_matrix -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = 5;
}

// SPIRV: Version: 1.6
