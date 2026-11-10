//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30108 (break-inside-defer) - 'break' inside defer
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30108
//META: catalog_name=break-inside-defer
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `defer` body runs during scope exit, so it may not itself transfer control
// out of that scope. `break` inside `defer` is rejected even though the `defer`
// sits inside a loop, and the CHECK pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { for (int i = 0; i < 2; i++) { defer { break; } } }

//CHECK: E30108
