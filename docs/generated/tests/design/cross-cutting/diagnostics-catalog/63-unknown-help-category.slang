//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E00063 (unknown-help-category) - unknown help category
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=63
//META: catalog_name=unknown-help-category
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `-h <category>` only accepts the driver's known help categories. An unknown
// category is diagnosed rather than silently printing general help; the CHECK
// pins that code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-h bogusHelpCategory
[numthreads(1,1,1)]
void main() {}

//CHECK: E00063
