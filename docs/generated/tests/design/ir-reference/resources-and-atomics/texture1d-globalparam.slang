//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#shader-io
//META: purpose=A module-scope `Texture1D` parameter surfaces as a `global_param` whose result type is `TextureType(..., TextureShape1DType, ...)`.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a texture parameter's shape is carried on the
// `global_param`'s result type rather than being erased to a generic
// resource. The CHECK pins the 1D shape tag inside the texture type on
// the parameter line.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform Texture1D<float4> tex;
uniform RWStructuredBuffer<int> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outbuf[0] = (int)tex.Load(int2(0, 0)).x;
}

// IR: %tex{{.*}}: TextureType({{.*}}TextureShape1DType{{.*}}= global_param
