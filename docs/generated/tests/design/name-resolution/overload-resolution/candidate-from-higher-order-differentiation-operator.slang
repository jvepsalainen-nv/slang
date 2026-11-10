//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-where-candidates-come-from
//META: purpose=AddHigherOrderOverloadCandidates contributes candidates for operators such as __fwd_diff that wrap a callee, so the wrapped function resolves and is applied.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the higher-order candidate family. The callee is not a plain
// decl-ref but `__fwd_diff(sq)`, whose candidate is built by the higher-order
// helper from the wrapped function. CHECK asserts the derivative value 6, which
// is only produced if the wrapping candidate resolved and the call was built.

//TEST:INTERPRET(filecheck=CHECK):

[Differentiable]
float sq(float x) { return x * x; }

void main()
{
    var r = __fwd_diff(sq)(diffPair(3.0, 1.0));
    // CHECK: d=6.0
    printf("d=%.1f\n", r.d);
}
