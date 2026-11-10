//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38108 (parameter-direction-does-not-match-requirement) - parameter direction mismatch
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38108
//META: catalog_name=parameter-direction-does-not-match-requirement
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An implementer's parameter direction differs from the
// interface requirement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo
{
    void f(out int x);
}

struct S : IFoo
{
    void f(int x) {}
}

//CHECK: E38108
