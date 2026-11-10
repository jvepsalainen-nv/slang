//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#texture-and-image
//META: purpose=`rwtex[xyz]` rvalue on an `RWTexture3D<T>` surfaces in `main` as a `call specialize(..., TextureShape3DType, ...)(%rwtex, %xyz)` — the 3D + RW witness of the doc's `imageSubscript` opcode in its `call`-form pre-inline shape.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// 3D variant of the `[]`-on-RWTexture call shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWTexture3D<float4> rwtex;
uniform RWStructuredBuffer<float4> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outbuf[0] = rwtex[tid];
}

// IR-LABEL: func %main
// IR: call specialize({{.*}}TextureShape3DType{{.*}})({{.*}}%rwtex{{.*}})
