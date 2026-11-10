//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E54002 (mesh-output-must-be-array) - mesh output must be array
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=54002
//META: catalog_name=mesh-output-must-be-array
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// HLSL-style mesh outputs must be arrays. A scalar output parameter
// triggers the must-be-array error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage mesh

struct V { float4 pos : SV_POSITION; };

[outputtopology("triangle")]
[numthreads(1,1,1)]
[shader("mesh")]
void main(out vertices V vert) {
    SetMeshOutputCounts(0,0);
}

//CHECK: E54002
