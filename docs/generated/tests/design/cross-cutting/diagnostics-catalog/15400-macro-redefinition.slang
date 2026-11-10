//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15400 (macro-redefinition) - macro redefined
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15400
//META: catalog_name=macro-redefinition
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Redefining an object-like macro with a different body is legal but warned
// about, so a shadowed definition is not silent. The CHECK pins the
// macro-redefinition warning.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#define DUP_MACRO 1
#define DUP_MACRO 2
void main() {}

//CHECK: E15400
