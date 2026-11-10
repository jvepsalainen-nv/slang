//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30002 (divide-by-zero) - divide by zero
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30002
//META: catalog_name=divide-by-zero
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Constant folding evaluates integer division at compile time, so a literal
// zero divisor is caught before codegen. The CHECK pins the divide-by-zero
// error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
void main() { int x = 1 / 0; }

//CHECK: E30002
