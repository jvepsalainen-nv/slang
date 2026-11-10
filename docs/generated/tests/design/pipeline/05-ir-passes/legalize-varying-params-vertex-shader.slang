//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Expansion: legalize-varying-params routes a vertex-shader output `SV_Position` into the per-target stage-output marker on HLSL and GLSL — alternative pipeline-stage shape.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Legalize varying params" row of the type-and-value
// legalization table (`slang-ir-legalize-varying-params.cpp`)
// handles stage inputs/outputs. A vertex-shader entry point with
// `SV_Position` output exercises the output direction.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage vertex -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage vertex -entry main

float4 main(uint vid : SV_VertexID) : SV_Position
{
    return float4(float(vid), 0.0f, 0.0f, 1.0f);
}

// HLSL: SV_POSITION
// GLSL: gl_Position
