//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E40010 (float-literal-too-small) - floating-point literal too small
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=40010
//META: catalog_name=float-literal-too-small
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A non-zero float literal smaller than the smallest
// representable subnormal of the target type triggers E40010.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

static const half g = 1.0e-30h;

//CHECK: E40010