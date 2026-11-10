//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30009 (invalid-type-void) - invalid type 'void'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30009
//META: catalog_name=invalid-type-void
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `void` is not a storable type, so it cannot be the type of a variable. The
// CHECK pins the invalid-void-type error that rejects the declaration.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { void v; }

//CHECK: E30009
