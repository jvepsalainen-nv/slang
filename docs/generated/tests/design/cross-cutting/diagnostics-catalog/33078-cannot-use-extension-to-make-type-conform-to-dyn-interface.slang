//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33078 (cannot-use-extension-to-make-type-conform-to-dyn-interface) - extension cannot conform to dyn interface
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33078
//META: catalog_name=cannot-use-extension-to-make-type-conform-to-dyn-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An extension making a type conform to a `dyn` interface is
// rejected under Slang 2026 semantics.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

dyn interface IFoo
{
    int f();
}

struct S {}

extension S : IFoo
{
    int f() { return 0; }
}

//CHECK: E33078
