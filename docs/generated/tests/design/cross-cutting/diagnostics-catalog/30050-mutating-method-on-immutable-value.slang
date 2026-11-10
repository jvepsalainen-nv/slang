//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30050 (mutating-method-on-immutable-value) - mutating method cannot be called on immutable value
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30050
//META: catalog_name=mutating-method-on-immutable-value
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `[mutating]` method may modify `this`, so it may only be called on a
// mutable value. Calling it on a `const` local is rejected, and the CHECK pins
// that error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
struct S { int a; [mutating] void m() { a = 1; } }
void main() { const S s = {1}; s.m(); }

//CHECK: E30050
