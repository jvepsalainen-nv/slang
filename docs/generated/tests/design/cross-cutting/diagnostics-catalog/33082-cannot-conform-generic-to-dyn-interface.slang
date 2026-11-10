//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33082 (cannot-conform-generic-to-dyn-interface) - generic type cannot conform to dyn interface
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33082
//META: catalog_name=cannot-conform-generic-to-dyn-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A generic type conforming to a `dyn` interface is rejected.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

dyn interface IFoo
{
    int f();
}

struct G<T : IArithmetic> : IFoo
{
    T v;
    int f() { return 0; }
}

//CHECK: E33082
