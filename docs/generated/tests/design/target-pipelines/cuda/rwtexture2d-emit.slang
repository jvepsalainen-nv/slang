//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/cuda.md#phase-b-specialization-and-type-legalization
//META: purpose=RWTexture2D<float4> maps to the CUDA primitive CUsurfObject and subscript-store / subscript-load lower to surf2Dwrite / surf2Dread.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `lowerBuiltinTypesForKernelEntryPoints` rewrites RWTexture2D
// into a CUDA surface-object field (`CUsurfObject`) — distinct
// from the texture-object family used by read-only Texture*. The
// subscript-store / subscript-load on the read-write 2D texture
// lower to `surf2Dwrite<T>(...)` / `surf2Dread<T>(...)`.

//TEST:SIMPLE(filecheck=CHECK):-target cuda -entry main -stage compute

RWTexture2D<float4> tex;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    tex[tid.xy] = float4(1.0);
    outBuf[tid.x] = tex[tid.xy];
}

// CHECK: CUsurfObject
// CHECK: surf2Dwrite
// CHECK: surf2Dread
