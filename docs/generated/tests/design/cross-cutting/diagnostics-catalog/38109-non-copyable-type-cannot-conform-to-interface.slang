//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38109 (non-copyable-type-cannot-conform-to-interface) - non-copyable interface conformance is not fully supported
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38109
//META: catalog_name=non-copyable-type-cannot-conform-to-interface
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A non-copyable type conforming to an interface produces E38109.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo
{
    int f();
}

[__NonCopyableType]
struct S : IFoo
{
    int f() { return 0; }
}

//CHECK: E38109