//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30016 (call-operator-not-found) - no call operation found for type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30016
//META: catalog_name=call-operator-not-found
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A call expression requires a callable callee. An `int` local has no call
// operator, so the CHECK pins the no-call-operation error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = 0; x(); }

//CHECK: E30016
