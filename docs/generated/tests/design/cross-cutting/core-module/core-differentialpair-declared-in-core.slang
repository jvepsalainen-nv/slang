//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#what-the-core-module-provides
//META: purpose=IDifferentiable and the DifferentialPair magic type are declared in the core module itself, so a differentiable function and fwd_diff work without importing the diff meta-module.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the autodiff vocabulary that lives in the core module (as
// opposed to the diff meta-module) is reachable with no import: a
// user struct conforms to IDifferentiable, a DifferentialPair<float>
// is built with diffPair, and fwd_diff is applied to a [Differentiable]
// function. The CHECK pins f(3) = 9 with derivative 6, so the pair's
// primal and differential slots both had to be carried correctly.

//TEST:INTERPRET(filecheck=CHECK):

struct Point : IDifferentiable
{
    float x;
}

[Differentiable]
float square(float x) { return x * x; }

void main()
{
    DifferentialPair<float> dp = diffPair(3.0, 1.0);
    var r = fwd_diff(square)(dp);
    Point.Differential z = Point.dzero();
    // CHECK: p=9.0 d=6.0 dzero=0.0
    printf("p=%.1f d=%.1f dzero=%.1f\n", r.p, r.d, z.x);
}
