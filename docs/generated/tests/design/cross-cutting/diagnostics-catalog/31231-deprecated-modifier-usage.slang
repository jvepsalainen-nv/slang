//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31231 (deprecated-modifier-usage) - use of deprecated modifier
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=31231
//META: catalog_name=deprecated-modifier-usage
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// 'volatile' is deprecated in Slang 2025; using it triggers E31231.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2025

static volatile int b;

//CHECK: E31231