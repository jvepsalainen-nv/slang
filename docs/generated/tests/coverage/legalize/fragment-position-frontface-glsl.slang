//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#legalizeentrypointsforglsl-despite-the-name
//META: purpose=Verifies a fragment SV_Position input maps to gl_FragCoord and SV_IsFrontFace maps to the boolean gl_FrontFacing builtin in emitted GLSL.
//META: intent=characterization
//META: covers=source/slang/slang-ir-glsl-legalize.cpp
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pins the fragment-stage input system-value mapping: SV_Position as a
// fragment *input* (not the vertex output gl_Position) maps to
// gl_FragCoord, and the boolean SV_IsFrontFace maps to gl_FrontFacing.
// Both values feed the returned color so neither is eliminated; CHECK
// asserts both builtin names appear.
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage fragment

[shader("fragment")]
float4 main(float4 pos : SV_Position, bool ff : SV_IsFrontFace) : SV_Target
{
    return pos + (ff ? float4(1) : float4(0));
}

// Fragment SV_Position is the screen-space coordinate builtin.
//GLSL-DAG: gl_FragCoord
// SV_IsFrontFace is the boolean facing builtin.
//GLSL-DAG: gl_FrontFacing
