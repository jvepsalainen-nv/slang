//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#texture-sampler-and-texture-intrinsic-spellings
//META: purpose=Texture2DMS emits texture_multisampled_2d<f32>, a depth texture emits texture_depth_2d with no type parameter, SamplerComparisonState emits sampler_comparison, and SampleCmpLevelZero maps to textureSampleCompareLevel
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture2DMS<float4> t;
DepthTexture2D sh;
SamplerComparisonState cs;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = t.Load(int2(1,1), 0) + sh.SampleCmpLevelZero(cs, float2(0.5,0.5), 0.5f);
}

// CHECK: var t_0 : texture_multisampled_2d<f32>;
// CHECK: var sh_0 : texture_depth_2d;
// CHECK: var cs_0 : sampler_comparison;
// CHECK: textureSampleCompareLevel
