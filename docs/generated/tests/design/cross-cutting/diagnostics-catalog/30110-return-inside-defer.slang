//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30110 (return-inside-defer) - 'return' inside defer
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30110
//META: catalog_name=return-inside-defer
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `return` inside a `defer` body would abandon the scope exit that is already
// in progress. The CHECK pins the return-inside-defer error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { defer { return; } }

//CHECK: E30110
