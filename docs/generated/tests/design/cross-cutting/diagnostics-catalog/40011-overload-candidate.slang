//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic 40011 (overload-candidate) - candidate note after overload error
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=40011
//META: catalog_name=overload-candidate
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A wrong-argument-count call produces an error followed by a
// 40011 candidate note pointing at the function signature.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void f(int a, int b) {}

void main()
{
    f(1);
}

//CHECK: 40011
