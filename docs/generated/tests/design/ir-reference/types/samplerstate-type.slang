//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/types.md#resource-and-texture-types
//META: purpose=A uniform SamplerState declaration lowers to a global_param of IR type SamplerState.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A uniform SamplerState declaration lowers to a global_param of IR
// type SamplerState. A `uniform SamplerState samp;` surfaces
// `SamplerState` as the IR type on the `global_param`.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform SamplerState samp;
uniform Texture2D<float4> tex;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = tex.SampleLevel(samp, float2(0, 0), 0).x;
}

// IR: let {{.*}}%samp{{.*}}: SamplerState{{.*}}= global_param
