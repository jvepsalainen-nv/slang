//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15612 (pragma-warning-push-not-popped) - unmatched push
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15612
//META: catalog_name=pragma-warning-push-not-popped
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `#pragma warning(push)` that is never popped leaves the diagnostic-state
// stack unbalanced at end of translation. The CHECK pins the not-popped
// warning code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):
#pragma warning(push)
void main() {}

//CHECK: E15612
