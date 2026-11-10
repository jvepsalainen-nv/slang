//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=The `no_diff` type modifier suppresses differentiation through a parameter.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `no_diff` attaches to the parameter's type and removes it from the
// differentiable set. `scaledSum(x, scale)` is differentiated with respect to `x`
// only; the second argument is passed as a plain value, which is legal only
// because `no_diff` took it out of the derivative signature. CHECK asserts the
// derivative is 5 (the scale), the value that d/dx of `x * scale` must produce.

//TEST:INTERPRET(filecheck=CHECK):

[Differentiable]
float scaledSum(float x, no_diff float scale)
{
    return x * scale;
}

void main()
{
    DifferentialPair<float> px = DifferentialPair<float>(2.0, 1.0);
    DifferentialPair<float> r = fwd_diff(scaledSum)(px, 5.0);
    //CHECK: deriv=5
    printf("deriv=%d\n", int(r.d));
}
