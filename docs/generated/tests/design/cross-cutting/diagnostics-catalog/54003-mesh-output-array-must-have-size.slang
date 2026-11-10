//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E54003 (mesh-output-array-must-have-size) - mesh output array must have size
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=54003
//META: catalog_name=mesh-output-array-must-have-size
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// HLSL-style mesh output arrays must declare a length. An unbounded
// `[]` array triggers the missing-size error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage mesh

struct V { float4 pos : SV_POSITION; };

[outputtopology("triangle")]
[numthreads(1,1,1)]
[shader("mesh")]
void main(out vertices V verts[]) {
    SetMeshOutputCounts(0,0);
}

//CHECK: E54003
