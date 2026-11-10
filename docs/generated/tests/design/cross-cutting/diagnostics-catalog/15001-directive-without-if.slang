//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E15001 (directive-without-if) - '~directive' directive without '#if'
//META: intent=negative
//META: pipeline_stage=preprocess
//META: catalog_code=15001
//META: catalog_name=directive-without-if
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#endif` is only meaningful inside a conditional. A bare `#endif` with no
// matching `#if` is rejected, and the CHECK pins that code.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#endif
void main() {}

//CHECK: E15001
