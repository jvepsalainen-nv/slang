//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30620 (var-without-type-must-have-initializer) -- a variable declaration without an initial-value expression must be given an explicit type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30620
//META: catalog_name=var-without-type-must-have-initializer
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

var x;
[shader("compute")][numthreads(1,1,1)]
void main() {}


//CHECK: E30620
