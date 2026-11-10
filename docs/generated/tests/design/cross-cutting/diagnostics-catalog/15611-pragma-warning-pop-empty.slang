//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15611 (pragma-warning-pop-empty) - unmatched pop
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15611
//META: catalog_name=pragma-warning-pop-empty
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#pragma warning(push/pop)` maintains a stack of diagnostic states. A `pop`
// with an empty stack is unmatched, and the CHECK pins that warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#pragma warning(pop)
void main() {}

//CHECK: E15611
