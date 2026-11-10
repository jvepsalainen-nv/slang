//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#option-set-toggles
//META: purpose=The Vulkan-cross-API option flag -fvk-invert-y enables invertYOfPositionOutput; the IR pass negates the y component of the SV_Position output before the writeback in the emitted target text.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `VulkanInvertY` option-set toggle: when `-fvk-invert-y` is
// passed, `invertYOfPositionOutput` negates the y component of the position
// output before it reaches the emitted code. The test writes a runtime-fed
// `SV_Position` from a vertex entry point (a literal would be constant-folded
// away) and CHECKs for the negation in the emitted text; without the toggle
// the pass does not run and no negation appears.

//TEST:SIMPLE(filecheck=CHECK):-target glsl -entry main -stage vertex -profile vs_5_1 -fvk-invert-y

struct VOutput
{
    float4 v : SV_Position;
}

VOutput main()
{
    VOutput output;
    output.v = float4(1, 2, 3, 4);
    return output;
}

// CHECK: .y = -
// CHECK: gl_Position
