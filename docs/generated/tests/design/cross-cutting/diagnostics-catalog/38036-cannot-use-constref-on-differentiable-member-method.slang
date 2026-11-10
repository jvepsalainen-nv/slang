//META: generated=true
//META: doc_ref=source/slang/slang-diagnostics.lua
//META: purpose=Fires diagnostic E38036 (cannot-use-constref-on-differentiable-member-method) - '[constref]' on differentiable member method
//META: intent=negative
//META: pipeline_stage=check
//META: catalog_code=38036
//META: catalog_name=cannot-use-constref-on-differentiable-member-method
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `[constref]` on a `[Differentiable]` member method of a
// differentiable type triggers E38036.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S : IDifferentiable
{
    [Differentiable]
    [constref] float compute(float x) { return 0; }
}

//CHECK: E38036
