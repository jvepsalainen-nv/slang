//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30117 (forward-reference-in-generic-constraint) - forward reference in generic constraint
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30117
//META: catalog_name=forward-reference-in-generic-constraint
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Constraint that mentions a generic parameter declared later triggers the diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IThing {}

void f<T : U, U : IThing>() {}

void main() {}

//CHECK: 30117
