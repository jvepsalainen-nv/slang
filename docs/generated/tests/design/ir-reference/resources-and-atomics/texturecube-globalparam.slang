//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#shader-io
//META: purpose=A module-scope `TextureCube` parameter surfaces as a `global_param` whose result type is `TextureType(..., TextureShapeCubeDType, ...)`.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pins the `TextureShapeCubeDType` carrier on a module-scope
// `TextureCube` parameter's `global_param` result type.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform TextureCube<float4> tex;
uniform SamplerState samp;
uniform RWStructuredBuffer<float4> outbuf;

[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outbuf[0] = tex.Sample(samp, float3(0, 0, 1));
}

// IR: %tex{{.*}}: TextureType({{.*}}TextureShapeCubeDType{{.*}}= global_param
