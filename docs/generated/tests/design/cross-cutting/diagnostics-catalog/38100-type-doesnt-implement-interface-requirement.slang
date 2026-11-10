//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38100 (type-doesnt-implement-interface-requirement) - missing interface member
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38100
//META: catalog_name=type-doesnt-implement-interface-requirement
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A struct declared to conform to an interface but missing one
// of its required members triggers E38100.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo
{
    int f();
}

struct S : IFoo
{
}

//CHECK: E38100
