//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E31152 (cannot-associate-interface-requirement-with-derivative) -- interface requirement cannot have derivative
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=31152
//META: catalog_name=cannot-associate-interface-requirement-with-derivative
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface I {
    [BackwardDerivative(deriv)]
    float f(float x);
}


//CHECK: E31152
