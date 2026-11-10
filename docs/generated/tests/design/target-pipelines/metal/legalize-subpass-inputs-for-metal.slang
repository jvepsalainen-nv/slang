//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#legalizeirformetal
//META: purpose=`legalizeSubpassInputsForMetal` turns each `SubpassInput<T>` global into a fragment parameter carrying `[[color(N)]]` taken from its input-attachment index, and rewrites every `SubpassLoad` into a reference to it.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the frame-buffer-fetch mapping. Metal has no `subpassLoad`
// intrinsic, so the construct is mapped onto the per-fragment `[[color(N)]]`
// input instead, and any `SubpassLoad` that survived would abort the Metal
// emitter outright. Two attachments with different indices are read so the
// index really comes from the layout decoration rather than declaration
// order; CHECK asserts both `color(0)` and `color(3)` appear and that no
// `SubpassInput` / `SubpassLoad` token is left in the MSL.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage fragment

[[vk::input_attachment_index(0)]] SubpassInput<float4> inputColor;
[[vk::input_attachment_index(3)]] SubpassInput<float4> inputHigh;

[shader("fragment")]
float4 main() : SV_Target
{
    return inputColor.SubpassLoad() + inputHigh.SubpassLoad();
}

// CHECK: #include <metal_stdlib>
// CHECK: fragment{{.*}} main_0
// The two SubpassInputs land on separate `[[color(N)]]` attachments:
// CHECK-DAG: color(0)
// CHECK-DAG: color(3)
// CHECK-NOT: SubpassInput
// CHECK-NOT: SubpassLoad
