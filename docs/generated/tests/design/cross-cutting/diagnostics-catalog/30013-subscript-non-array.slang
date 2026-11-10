//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30013 (subscript-non-array) - invalid subscript expression
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30013
//META: catalog_name=subscript-non-array
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Subscripting requires an array, vector, matrix, or a type with a subscript
// operator. Applying `[]` to a scalar `int` has no such operation, and the
// CHECK pins the invalid-subscript error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
void main() { int x = 0; int y = x[0]; }

//CHECK: E30013
