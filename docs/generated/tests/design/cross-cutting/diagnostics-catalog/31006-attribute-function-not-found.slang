//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31006 (attribute-function-not-found) -- function not found for attribute
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31006
//META: catalog_name=attribute-function-not-found
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[domain("tri")]
[outputcontrolpoints(3)]
[outputtopology("triangle_cw")]
[partitioning("integer")]
[patchconstantfunc("nothere")]
void main() {}


//CHECK: E31006
