//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33073 (cannot-have-associated-type-in-dyn-interface) - dyn interfaces cannot have associatedType members
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33073
//META: catalog_name=cannot-have-associated-type-in-dyn-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `dyn` interface containing an associatedtype is rejected
// under Slang 2026 semantics.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

dyn interface IFoo
{
    associatedtype T;
}

//CHECK: E33073
