//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#shader-io
//META: purpose=A module-scope `RWTexture3D<T>` parameter surfaces as a `global_param` whose result type is `TextureType(..., TextureShape3DType, 0, 0, 0, 1, ...)`, combining 3D shape with the RW-access flag.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `RWTexture3D<T>` combines 3D shape with the RW flag.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWTexture3D<float4> rwtex;
uniform RWStructuredBuffer<int> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    rwtex[tid] = float4(0, 0, 0, 0);
    outbuf[0] = 1;
}

// IR: %rwtex{{.*}}: TextureType({{.*}}TextureShape3DType, 0 : Int, 0 : Int, 0 : Int, 1 : Int{{.*}}= global_param
