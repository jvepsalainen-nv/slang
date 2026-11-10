//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30831 (cannot-inherit-from-implicitly-sealed-declaration-in-another-module) -- cannot inherit from type '~baseType:Type' in module '~moduleName:Name' because it is implicitly 'sealed'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30831
//META: catalog_name=cannot-inherit-from-implicitly-sealed-declaration-in-another-module
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S : String {}


//CHECK: E30831
