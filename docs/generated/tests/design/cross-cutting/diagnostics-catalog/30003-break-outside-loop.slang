//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30003 (break-outside-loop) - 'break' must appear inside loop or switch constructs
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30003
//META: catalog_name=break-outside-loop
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `break` needs an enclosing loop or `switch` to exit. At function-body scope
// there is none, and the CHECK pins the break-outside-loop error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { break; }

//CHECK: E30003
