//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38046 (geometry-shader-missing-max-vertex-count) - geometry shader missing [maxvertexcount] attribute
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38046
//META: catalog_name=geometry-shader-missing-max-vertex-count
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A geometry shader entry point without `[maxvertexcount(...)]`
// triggers E38046.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage geometry -entry main -profile sm_5_0

struct V { float4 pos : SV_Position; };

void main(triangle float4 verts[3] : SV_Position, inout TriangleStream<V> outStream) {}

//CHECK: E38046
