//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30201 (function-redefinition) - function '~function' already has a body
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30201
//META: catalog_name=function-redefinition
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A function may be declared many times but defined once. A second body for the
// same signature is a redefinition, which the CHECK pins by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void f() {}
void f() {}
void main() { f(); }

//CHECK: E30201
