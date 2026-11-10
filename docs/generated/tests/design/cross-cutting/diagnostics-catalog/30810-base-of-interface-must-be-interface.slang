//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30810 (base-of-interface-must-be-interface) -- interface '~decl:Decl' cannot inherit from non-interface type '~baseType:Type'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30810
//META: catalog_name=base-of-interface-must-be-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S {}
interface I : S {}


//CHECK: E30810
