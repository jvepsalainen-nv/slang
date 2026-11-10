//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30312 (interface-requirement-cannot-be-override) - interface requirement cannot override
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30312
//META: catalog_name=interface-requirement-cannot-be-override
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Using `override` on an interface requirement is invalid.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IBase { int get(); }

interface IDerived : IBase
{
    override int get();
}

void main() {}

//CHECK: 30312
