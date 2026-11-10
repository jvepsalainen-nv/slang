//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30100 (static-ref-to-non-static-member) - type cannot refer to non-static member
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30100
//META: catalog_name=static-ref-to-non-static-member
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Referring to a non-static struct member via the type name is invalid.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S { int x; };

void main()
{
    int v = S.x;
}

//CHECK: 30100
