//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#texture-sampler-and-texture-intrinsic-spellings
//META: purpose=For an array texture the intrinsic template splits the coordinate rather than passing it whole: the trailing component becomes a separate layer argument spelled i32(...).
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The access intrinsics are not emitter arms — each is a `case wgsl:` arm of a
// `__target_switch` in hlsl.meta.slang whose body is an `__intrinsic_asm`
// template. For an array texture that template does something a reader would
// not predict from the Slang call: it splits the coordinate, passing the
// leading components as the coordinate and the trailing component as a
// separate layer argument.
//
// The layer argument is a distinct branch from the coordinate itself, so the
// CHECK pins the split shape — `.xy` followed by an `i32(...)` layer — rather
// than merely asserting that `textureSampleLevel` appears. The non-array
// sibling in the same file is the contrast: its coordinate is passed whole,
// with no layer argument.

//TEST:SIMPLE(filecheck=CHECK):-target wgsl -entry main -stage compute

Texture2DArray<float4> texArray;
Texture2D<float4> texPlain;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = texArray.SampleLevel(samp, float3(0.5, 0.5, 1.0), 0.0);
    outBuf[1] = texPlain.SampleLevel(samp, float2(0.5, 0.5), 0.0);
}

// The array texture keeps its _array-suffixed type name. Both declarations are
// emitted as module-scope vars, ahead of the function body, so they are matched
// before the call below.
// CHECK-DAG: texture_2d_array<f32>
// CHECK-DAG: texture_2d<f32>
// The array coordinate is split: leading components, then an i32 layer index.
// CHECK: textureSampleLevel({{.*}}.xy, i32({{.*}}.z)
