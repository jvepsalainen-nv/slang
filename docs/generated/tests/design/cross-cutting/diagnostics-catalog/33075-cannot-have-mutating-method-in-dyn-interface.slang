//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33075 (cannot-have-mutating-method-in-dyn-interface) - dyn interfaces cannot have [mutating] methods
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33075
//META: catalog_name=cannot-have-mutating-method-in-dyn-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `dyn` interface containing a [mutating] method is rejected
// under Slang 2026 semantics.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

dyn interface IFoo
{
    [mutating]
    void mut(int v);
}

//CHECK: E33075
