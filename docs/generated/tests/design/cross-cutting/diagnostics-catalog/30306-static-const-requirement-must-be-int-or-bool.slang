//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E30306 (static-const-requirement-must-be-int-or-bool) - invalid static const requirement type
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=30306
//META: catalog_name=static-const-requirement-must-be-int-or-bool
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// An interface 'static const' requirement of a non-int/bool type is invalid.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IHasFloat
{
    static const float k;
}

void main() {}

//CHECK: 30306
