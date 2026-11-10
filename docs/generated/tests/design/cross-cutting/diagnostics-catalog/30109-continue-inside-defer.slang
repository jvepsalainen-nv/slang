//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30109 (continue-inside-defer) - 'continue' inside defer
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30109
//META: catalog_name=continue-inside-defer
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `continue` inside a `defer` body would re-enter the loop from a scope that is
// already unwinding. It is rejected with its own code, which the CHECK pins.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { for (int i = 0; i < 2; i++) { defer { continue; } } }

//CHECK: E30109
