//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00062 (unknown-command-line-value) - unknown value for option '~option'. Valid values are '~validValues'
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=62
//META: catalog_name=unknown-command-line-value
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Enumerated options reject values outside their documented value list. A
// made-up `-line-directive-mode` value fires the generic unknown-value error,
// which the CHECK pins by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-line-directive-mode bogusmode
[numthreads(1,1,1)]
void main() {}

//CHECK: E00062
