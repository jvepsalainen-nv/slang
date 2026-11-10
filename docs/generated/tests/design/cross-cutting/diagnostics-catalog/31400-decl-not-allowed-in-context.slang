//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31400 (decl-not-allowed-in-context) - declaration not allowed in this context
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31400
//META: catalog_name=decl-not-allowed-in-context
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A non-static instance variable inside an interface is allowed
// by the parser but rejected by the semantic-check nesting table:
// instance variables may not appear in interfaces.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IFoo
{
    int x;
}

//CHECK: E31400
