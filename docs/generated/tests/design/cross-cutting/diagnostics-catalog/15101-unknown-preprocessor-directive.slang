//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15101 (unknown-preprocessor-directive) - unknown directive
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15101
//META: catalog_name=unknown-preprocessor-directive
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Directive names are matched against a fixed set. A `#`-prefixed name outside
// that set is diagnosed as an unknown directive rather than skipped, which the
// CHECK observes by code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#bogusdirective
void main() {}

//CHECK: E15101
