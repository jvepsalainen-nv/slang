//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30830 (cannot-inherit-from-explicitly-sealed-declaration-in-another-module) -- cannot inherit from type '~baseType:Type' marked 'sealed' in module '~moduleName:Name'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30830
//META: catalog_name=cannot-inherit-from-explicitly-sealed-declaration-in-another-module
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S : __BuiltinIntegerType {}


//CHECK: E30830
