//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33077 (dyn-interface-cannot-inherit-non-dyn-interface) - dyn interface inheritance error
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33077
//META: catalog_name=dyn-interface-cannot-inherit-non-dyn-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `dyn` interface inheriting from a non-`dyn` interface is
// rejected under Slang 2026 semantics.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

interface IBase
{
}

dyn interface IFoo : IBase
{
    int f(int v);
}

//CHECK: E33077
