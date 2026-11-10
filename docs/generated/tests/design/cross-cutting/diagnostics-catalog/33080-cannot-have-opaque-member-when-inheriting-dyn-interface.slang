//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E33080 (cannot-have-opaque-member-when-inheriting-dyn-interface) - opaque member with dyn interface inheritance
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=33080
//META: catalog_name=cannot-have-opaque-member-when-inheriting-dyn-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A struct inheriting a `dyn` interface and containing an opaque
// (resource) member is rejected.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-std 2026

dyn interface IFoo
{
}

struct S : IFoo
{
    Texture2D<float> tex;
}

//CHECK: E33080
