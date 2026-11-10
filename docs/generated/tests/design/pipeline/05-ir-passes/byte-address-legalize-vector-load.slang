//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Expansion: byte-address-legalize handles vector-typed loads — `ByteAddressBuffer.Load<float4>(0)` lowers to a vector-shaped read on GLSL with the `babuf` SSBO surviving.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Parameter-shape axis on byte-address-legalize: the loaded element
// is a `float4` vector rather than a scalar. The legalize pass must
// handle the vector shape correctly on GLSL.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform ByteAddressBuffer babuf;
uniform RWStructuredBuffer<float4> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = babuf.Load<float4>(0);
}

// GLSL: layout(std430
// GLSL: babuf
// GLSL: _data[
