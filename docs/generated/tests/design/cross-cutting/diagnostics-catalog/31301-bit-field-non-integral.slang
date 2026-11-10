//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31301 (bit-field-non-integral) - bit-field type must be integral
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31301
//META: catalog_name=bit-field-non-integral
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Bit-fields are only defined for integral storage. Declaring one on a `float`
// member is rejected, which the CHECK observes by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -entry main -stage compute
struct S { float a : 4; }
[numthreads(1,1,1)]
void main() { S s; }

//CHECK: E31301
