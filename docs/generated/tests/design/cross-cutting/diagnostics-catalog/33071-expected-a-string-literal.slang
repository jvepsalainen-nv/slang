//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33071 (expected-a-string-literal) - expected a string literal
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33071
//META: catalog_name=expected-a-string-literal
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `[shader(...)]` names its stage with a string literal. Passing an integer
// makes the attribute argument fail its literal-kind check, and the CHECK pins
// the expected-a-string-literal error.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute
[shader(1)]
void main() {}

//CHECK: E33071
