//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-b-specialization-and-type-legalization
//META: purpose=Texture2DArray<float4> maps to the CUDA primitive CUtexObject and SampleLevel lowers to tex2DLayeredLod<T>(...).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `lowerBuiltinTypesForKernelEntryPoints` replaces Slang's
// Texture2DArray with the CUDA primitive `CUtexObject`. A
// SampleLevel call with a `float3(coord_xy, layer)` lowers to
// `tex2DLayeredLod<T>(obj, x, y, int(layer), lod)`.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

Texture2DArray<float4> tex;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tex.SampleLevel(samp, float3(tid), 0);
}

// CHECK: CUtexObject
// CHECK: tex2DLayeredLod
