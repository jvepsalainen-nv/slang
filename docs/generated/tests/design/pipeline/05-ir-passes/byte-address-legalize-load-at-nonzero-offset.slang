//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=Expansion: byte-address-legalize rewrites a typed `ByteAddressBuffer.Load<int>(N)` at a non-zero offset into a typed indexed SSBO access on GLSL — the offset is divided by element size as part of the rewrite.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis on byte-offset: the load address is `16` rather than
// `0`. The legalize pass still produces a typed `_data[...]` access
// on GLSL — the `babuf` name survives and an indexed read appears.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform ByteAddressBuffer babuf;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = babuf.Load<int>(16);
}

// GLSL: layout(std430
// GLSL: babuf
// GLSL: _data[
