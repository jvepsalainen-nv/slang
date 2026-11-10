//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30702 (system-value-semantic-invalid-direction) -- system value semantic '~semantic' cannot be used as ~direction in '~stage' shader stage
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30702
//META: catalog_name=system-value-semantic-invalid-direction
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

[shader("vertex")]
void main(out float3 d : SV_VertexID) {}


//CHECK: E30702
