//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31123 (invalid-guid) -- invalid GUID
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31123
//META: catalog_name=invalid-guid
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[COM("not-a-guid")]
interface IFoo {}


//CHECK: E31123
