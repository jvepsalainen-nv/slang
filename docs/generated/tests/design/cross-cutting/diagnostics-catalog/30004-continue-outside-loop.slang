//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30004 (continue-outside-loop) - 'continue' must appear inside loop constructs
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30004
//META: catalog_name=continue-outside-loop
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `continue` needs an enclosing loop to continue. Placed directly in a function
// body it has no target, which the CHECK observes by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { continue; }

//CHECK: E30004
