//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#branch--flatten--loopcontrol
//META: purpose=The [branch] hint is consumed by the backend emit step: HLSL re-emits the [branch] attribute on the conditional and SPIR-V encodes the DontFlatten selection control on the conditional's merge.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `branch` carries no IR semantics of its own and is instead
// read by the backend to pick the divergent control-flow strategy. The HLSL
// CHECK asserts the attribute is printed back onto the `if`, and the SPIR-V
// CHECK asserts the same hint becomes the `DontFlatten` mask on
// `OpSelectionMerge`. Both observations are at final emit, which is where
// the doc says the hint is consumed.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -O0 -entry main -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int v = int(tid.x);

    [branch]
    if (tid.x > 1)
    {
        v = v + 7;
    }

    outputBuffer[tid.x] = v;
}

// HLSL: [branch]
// SPIRV: OpSelectionMerge {{.*}} DontFlatten
