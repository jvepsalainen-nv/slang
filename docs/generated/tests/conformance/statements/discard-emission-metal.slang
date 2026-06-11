//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:16:03+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/statements.md#discard-statement
//META: doc_section_digest=c2e15d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4
//META: purpose=discard in a fragment shader emits a discard instruction in the target output.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the discard statement lowers to Metal's `discard_fragment()` intrinsic.
// CHECK pins the emitted discard_fragment() call inside the alpha-test branch.
//TEST:SIMPLE(filecheck=CHECK):-target metal -entry fragMain -stage fragment

float4 fragMain(float4 color : COLOR) : SV_Target
{
    if (color.a < 0.1)
        discard;
    return color;
}

// CHECK: discard_fragment();
