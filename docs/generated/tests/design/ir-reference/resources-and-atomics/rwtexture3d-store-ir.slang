//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#texture-and-image
//META: purpose=`rwtex[xyz] = val` assignment on an `RWTexture3D<T>` surfaces in `main` as a `call specialize(..., TextureShape3DType, ...)(%rwtex, %xyz, %val)` — the 3D witness of the doc's `imageStore` opcode in its pre-inline `call` shape.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// 3D variant of the `[]=`-on-RWTexture call shape.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform RWTexture3D<float4> rwtex;
uniform RWStructuredBuffer<int> outbuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    rwtex[tid] = float4(1.0, 2.0, 3.0, 4.0);
    outbuf[0] = 1;
}

// IR-LABEL: func %main
// IR: call specialize({{.*}}TextureShape3DType{{.*}})({{.*}}%rwtex{{.*}})
