//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E40009 (float-literal-unrepresentable) - floating-point literal unrepresentable
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=40009
//META: catalog_name=float-literal-unrepresentable
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A float literal that exceeds the max representable value of
// the target type (here `half`) is converted with E40009.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

static const half g = 1.0e10h;

//CHECK: E40009