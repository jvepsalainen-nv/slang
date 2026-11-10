//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30061 (expected-a-namespace) - expected a namespace
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30061
//META: catalog_name=expected-a-namespace
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `using` directive applied to a non-namespace name triggers the diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S {}

using S;

void main() {}

//CHECK: E30061
