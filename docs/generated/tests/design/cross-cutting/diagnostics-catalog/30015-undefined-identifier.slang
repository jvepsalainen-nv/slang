//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30015 (undefined-identifier) - undefined identifier
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30015
//META: catalog_name=undefined-identifier
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Name lookup fails when no declaration is visible for an identifier. The CHECK
// pins the undefined-identifier error, which is the checker's report for an
// empty lookup result.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = notDefinedAnywhereXyz; }

//CHECK: E30015
