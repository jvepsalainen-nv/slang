//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31230 (removed-modifier-usage) - use of removed modifier
//META: intent=negative
//META: pipeline_stage=parse
//META: catalog_code=31230
//META: catalog_name=removed-modifier-usage
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// 'volatile' is removed in Slang 2026; using it triggers E31230.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

static volatile int b;

//CHECK: E31230
