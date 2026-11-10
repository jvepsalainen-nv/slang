//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30816 (inheritance-unstable) -- support for inheritance is unstable and will be removed in future language versions, consider using composition instead
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30816
//META: catalog_name=inheritance-unstable
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct A {}
struct B : A {}


//CHECK: E30816
