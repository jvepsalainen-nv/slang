//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#shader-io
//META: purpose=A module-scope `RWTexture1D<T>` parameter surfaces as a `global_param` whose result type is `TextureType(..., TextureShape1DType, 0, 0, 0, 1, ...)`, with the read-write access flag set.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `RWTexture1D<T>` flips the RW-access slot in the `TextureType(...)`
// operand list while keeping shape at 1D.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWTexture1D<float4> rwtex;
uniform RWStructuredBuffer<int> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    rwtex[tid.x] = float4(0, 0, 0, 0);
    outbuf[0] = 1;
}

// IR: %rwtex{{.*}}: TextureType({{.*}}TextureShape1DType, 0 : Int, 0 : Int, 0 : Int, 1 : Int{{.*}}= global_param
