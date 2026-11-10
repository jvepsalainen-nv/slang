//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30090 (try-clause-must-apply-to-invoke-expr) - expression in 'try' must be a call
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30090
//META: catalog_name=try-clause-must-apply-to-invoke-expr
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `try` propagates an error out of a call, so its operand must be a call
// expression. Applying it to a plain variable reference is rejected, which the
// CHECK observes by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = 0; try x; }

//CHECK: E30090
