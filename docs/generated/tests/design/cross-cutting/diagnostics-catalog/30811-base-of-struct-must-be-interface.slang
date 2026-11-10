//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30811 (base-of-struct-must-be-interface) -- struct '~decl:Decl' cannot inherit from non-interface type '~baseType:Type'
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30811
//META: catalog_name=base-of-struct-must-be-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

enum E { A }
struct S : E {}


//CHECK: E30811
