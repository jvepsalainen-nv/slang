//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38031 (invalid-use-of-no-diff) - invalid 'no_diff' usage
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38031
//META: catalog_name=invalid-use-of-no-diff
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Applying `no_diff` to a non-call, non-subscript expression
// triggers E38031.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[Differentiable]
float f(float x)
{
    return no_diff x;
}

//CHECK: E38031
