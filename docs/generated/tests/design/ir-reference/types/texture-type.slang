//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A uniform Texture2D<float4> declaration lowers to a global_param of IR type TextureType with element-type and TextureShape2DType operands.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A uniform Texture2D<float4> declaration lowers to a global_param of
// IR type TextureType with element-type and TextureShape2DType
// operands. `TextureShapeBufferType`).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform Texture2D<float4> tex;
uniform SamplerState samp;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = tex.SampleLevel(samp, float2(0, 0), 0).x;
}

// IR: let {{.*}}%tex{{.*}}: TextureType(Vec(Float, 4 : Int), TextureShape2DType{{.*}}= global_param
