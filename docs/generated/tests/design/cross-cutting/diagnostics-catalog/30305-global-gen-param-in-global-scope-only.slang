//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30305 (global-gen-param-in-global-scope-only) - type_param outside global scope
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30305
//META: catalog_name=global-gen-param-in-global-scope-only
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `type_param` declaration inside a function body is invalid.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    type_param T;
}

//CHECK: 30305
