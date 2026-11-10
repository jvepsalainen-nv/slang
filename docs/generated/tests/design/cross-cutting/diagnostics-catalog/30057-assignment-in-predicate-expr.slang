//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30057 (assignment-in-predicate-expr) - assignment in predicate expression not allowed
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30057
//META: catalog_name=assignment-in-predicate-expr
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An assignment used where a condition is expected is nearly always a typo for
// `==`. Slang rejects it outright rather than converting the assigned value to
// bool, and the CHECK pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = 0; if (x = 1) {} }

//CHECK: E30057
