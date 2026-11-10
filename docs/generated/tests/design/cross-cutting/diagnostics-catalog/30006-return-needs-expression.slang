//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30006 (return-needs-expression) - 'return' should have an expression
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30006
//META: catalog_name=return-needs-expression
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A function with a non-void return type must return a value on every path. A
// bare `return` in an `int`-returning function omits it, and the CHECK pins
// the return-needs-expression error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
int f() { return; }
void main() { f(); }

//CHECK: E30006
