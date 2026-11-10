//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/metadata.md#sampledtype--imagetype--sampledimagetype
//META: purpose=__truncate is a pseudo-opcode accepted in an inline-asm instruction's opcode operand, and __sampledType computes the result type of sampling an image of a given component type.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the pseudo-opcode occupies operand 0 where a real opcode number
// normally sits. Sampling a `Texture2D<float3>` goes through the core module's
// inline-asm fragment, which samples into the four-component result computed
// by `__sampledType` and then truncates. The CHECK requires `__truncate` in
// the leading operand position and the type function among the operands, which
// together show the opcode slot accepts more than an integer literal.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage fragment

Texture2D<float3> gTex;
SamplerState gSamp;

float4 main(float2 uv : TEXCOORD) : SV_Target
{
    return float4(gTex.Sample(gSamp, uv), 1);
}

// CHECK: SPIRVAsmInst({{[0-9]+}} : UInt, __sampledType({{.*}}), %"__sampled",
// CHECK-NEXT: SPIRVAsmInst(__truncate, {{.*}}result, __sampledType(
