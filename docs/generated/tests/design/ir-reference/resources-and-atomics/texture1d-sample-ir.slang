//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#sampling-and-combined-samplers
//META: purpose=`Texture1D::Sample(samp, u)` surfaces in `main` as a `call specialize(%Sample, ..., TextureShape1DType, ...)(%tex, %samp, %u)` against the library-level `%Sample` function (the doc's `sample` opcode lives inside the library helper body, not in `main`).
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per the existing bundle's "Doc gaps observed" notes, `Texture*::Sample`
// at LOWER-TO-IR surfaces as a `call specialize(%Sample, ...)` to a
// `[targetIntrinsic]`-tagged library helper. The `TextureShape1DType`
// token in the specialization args is the observable witness that
// the 1D variant was selected.

//TEST:SIMPLE(filecheck=IR):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform Texture1D<float4> tex;
uniform SamplerState samp;
uniform RWStructuredBuffer<float4> outbuf;

[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    float u = float(tid.x);
    outbuf[0] = tex.Sample(samp, u);
}

// IR-LABEL: func %main
// IR: call specialize({{.*}}TextureShape1DType{{.*}})({{.*}}%tex{{.*}}%samp{{.*}})
