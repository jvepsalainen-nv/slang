//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31125 (attribute-usage-attribute-must-be-on-non-generic-struct) -- [__AttributeUsage] requires non-generic struct
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31125
//META: catalog_name=attribute-usage-attribute-must-be-on-non-generic-struct
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[__AttributeUsage(1)]
struct MyAttr<T> {}


//CHECK: E31125
