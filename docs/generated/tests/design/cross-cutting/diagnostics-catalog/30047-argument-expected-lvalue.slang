//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30047 (argument-expected-lvalue) - argument must be l-value
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30047
//META: catalog_name=argument-expected-lvalue
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An `out` parameter is written back to its argument, so the argument must be
// an l-value. Passing a literal gives nothing to write back to, which the CHECK
// observes by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void f(out int x) { x = 1; }
void main() { f(1); }

//CHECK: E30047
