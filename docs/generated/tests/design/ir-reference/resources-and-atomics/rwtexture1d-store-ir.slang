//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#texture-and-image
//META: purpose=`rwtex[i] = val` assignment on an `RWTexture1D<T>` surfaces in `main` as a `call specialize(..., TextureShape1DType, ..., 1 : Int, ...)(%rwtex, %i, %val)` — the doc's `imageStore` opcode lives inside the helper; the call form is observable from `main`.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// 1D variant of the `[]=`-on-RWTexture call shape; the helper is
// parameterized by 1D shape and called with (texture, coord, value).

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWTexture1D<float4> rwtex;
uniform RWStructuredBuffer<int> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    rwtex[tid.x] = float4(1.0, 2.0, 3.0, 4.0);
    outbuf[0] = 1;
}

// IR-LABEL: func %main
// IR: call specialize({{.*}}TextureShape1DType{{.*}})({{.*}}%rwtex{{.*}})
