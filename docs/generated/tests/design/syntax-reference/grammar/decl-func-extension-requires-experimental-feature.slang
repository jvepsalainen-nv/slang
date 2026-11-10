//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=A user `__func_extension` declaration without `-experimental-feature` is reported with warning E30131 and not processed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the experimental gate on `__func_extension`; CHECK asserts the
// E30131 warning on a minimal `fwd_diff(foo)` extension compiled without the flag.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl

[ForwardDifferentiable]
float foo(float x) { return x * x; }

__func_extension fwd_diff(foo) (float x) -> DifferentialPair<float>
{
    return DifferentialPair<float>(x * x, 1.0f);
}

// CHECK: E30131
