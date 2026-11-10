//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#where-the-metal-specific-opcodes-come-from
//META: purpose=A comparison sample on a `Texture2D<float>` goes through the Metal-only `MetalCastToDepthTexture` opcode, emitted as a cast into `depth2d<float, access::sample>` before `sample_compare`.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second core-module-sourced Metal opcode. MSL splits colour
// and depth textures into distinct types and only `depth2d` offers
// `sample_compare`, so the declared `texture2d` parameter has to be
// reinterpreted at the use site. CHECK asserts a `depth2d<float,
// access::sample>` local is produced and that the comparison sample is
// issued on it.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

Texture2D<float> depthTex;
SamplerComparisonState cmpSamp;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = depthTex.SampleCmpLevelZero(cmpSamp, float2(0.5f, 0.5f), 0.5f);
}

// CHECK: depth2d<float, access::sample>
// CHECK: .sample_compare(
