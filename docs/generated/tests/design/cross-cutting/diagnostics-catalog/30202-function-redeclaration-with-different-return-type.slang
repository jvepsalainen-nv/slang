//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30202 (function-redeclaration-with-different-return-type) - function return type mismatch
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30202
//META: catalog_name=function-redeclaration-with-different-return-type
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Return type is not part of the overload signature, so a later declaration of
// the same function with a different return type conflicts with the earlier
// one. The CHECK pins that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void f();
int f() { return 1; }
void main() { f(); }

//CHECK: E30202
