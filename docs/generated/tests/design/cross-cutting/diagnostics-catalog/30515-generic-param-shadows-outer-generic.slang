//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30515 (generic-param-shadows-outer-generic) -- generic parameter '~param:Decl' shadows a generic parameter from an enclosing scope
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30515
//META: catalog_name=generic-param-shadows-outer-generic
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Outer<T> {
    void f<T>() {}
}


//CHECK: E30515
