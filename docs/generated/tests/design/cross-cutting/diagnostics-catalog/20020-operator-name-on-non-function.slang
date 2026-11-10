//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E20020 (operator-name-on-non-function) - operator name used to declare a non-function
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=20020
//META: catalog_name=operator-name-on-non-function
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An `operator` name may only introduce a function. Declaring it as a variable
// is rejected at parse time; the CHECK pins that code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
int operator+;
void main() {}

//CHECK: E20020
