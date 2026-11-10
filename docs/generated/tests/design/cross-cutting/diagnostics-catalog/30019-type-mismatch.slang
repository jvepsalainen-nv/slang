//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30019 (type-mismatch) - type mismatch in expression
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30019
//META: catalog_name=type-mismatch
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Initialization only succeeds when the initializer converts to the declared
// type. A 3-component vector does not convert to a scalar `int`, and the CHECK
// pins the type-mismatch error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = float3(1,2,3); }

//CHECK: E30019
