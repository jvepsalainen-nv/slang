//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#downstream-dxc--fxc
//META: purpose=DXC is invoked as the downstream compiler when -target dxil is requested; the artifact contains DXIL bytecode whose textual disassembly contains the DXIL entry-point definition.
//META: intent=expansion
//META: pipeline_stage=emit
//META: requires-tool=dxc
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that requesting `-target dxil` rides the same IR path as
// `-target hlsl` and then diverges only in the downstream dispatch, which
// hands the emitted HLSL to DXC. The test compiles the same compute kernel
// shape used by the HLSL-text tests; CHECK asserts the artifact contains
// LLVM-textual DXIL entry definitions, which can only appear if DXC actually
// ran on the emitted source. DXC is absent on the generation runner, so the
// directive is validated in CI.

//TEST:SIMPLE(filecheck=DXIL):-target dxil -profile cs_6_0 -entry main

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}

// DXIL: define void @
// DXIL: main
