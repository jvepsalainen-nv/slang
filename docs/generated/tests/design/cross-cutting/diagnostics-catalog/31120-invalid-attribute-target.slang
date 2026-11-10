//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31120 (invalid-attribute-target) -- invalid syntax target for user defined attribute
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31120
//META: catalog_name=invalid-attribute-target
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

[__AttributeUsage(7)]
struct MyAttr {}


//CHECK: E31120
