//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31000 (unknown-attribute-name) -- unknown attribute
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31000
//META: catalog_name=unknown-attribute-name
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[unknownAttr]
[shader("compute")][numthreads(1,1,1)]
void main() {}


//CHECK: E31000
