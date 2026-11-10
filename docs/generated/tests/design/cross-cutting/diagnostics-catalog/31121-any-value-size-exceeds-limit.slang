//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31121 (any-value-size-exceeds-limit) -- 'anyValueSize' exceeds limit
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31121
//META: catalog_name=any-value-size-exceeds-limit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[anyValueSize(99999)]
interface I {}


//CHECK: E31121
