//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Expansion: an RWTexture2D is written and read via uint2 subscript; HLSL emit preserves the native RWTexture2D spelling and `u` register.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// RWTexture2D is the UAV form of Texture2D. HLSL emit preserves
// the type name and binds it to a `u` register.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWTexture2D<float4> tex;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    tex[uint2(0, 0)] = float4(1.0, 0.0, 0.0, 1.0);
    outBuf[tid.x] = tex[uint2(0, 0)];
}

// CHECK: RWTexture2D{{.*}} tex_{{[0-9]+}} : register(u{{[0-9]+}})
