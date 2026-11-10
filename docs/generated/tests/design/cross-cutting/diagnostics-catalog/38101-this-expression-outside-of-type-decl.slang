//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38101 (this-expression-outside-of-type-decl) - 'this' used outside aggregate type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38101
//META: catalog_name=this-expression-outside-of-type-decl
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Using `this` from a global function triggers E38101.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int f()
{
    return this;
}

//CHECK: E38101
