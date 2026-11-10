//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30854 (override-modifier-not-overriding-base-decl) -- '~decl:Decl' marked as 'override' is not overriding any base declarations
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30854
//META: catalog_name=override-modifier-not-overriding-base-decl
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S {
    override int f() { return 1; }
}


//CHECK: E30854
