//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04-ast-to-ir.md#differentiability-arrives-as-a-conformance
//META: purpose=The synthesized `fwd_diff` member that the `IForwardDifferentiable` conformance of a `[Differentiable]` function requires lowers to an intrinsic inst carrying the decl's stored IR op, not to an ordinary `IRFunc` with a body.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `[Differentiable]` is consumed as an interface conformance
// rather than re-derived by lowering: the interface member the conformance
// requires is a synthesized decl, and lowering replaces the `IRFunc` it first
// creates with an intrinsic inst built from that decl's stored op. Calling
// `fwd_diff(sq)` forces the member to be lowered; the CHECKs pin the member's
// name hint and require the value bound to it to be a single
// `ForwardDifferentiate(%sq)` operand-form value rather than a function body.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -stage compute -entry main

uniform float a;
uniform RWStructuredBuffer<float> buf;

[Differentiable]
float sq(float x)
{
    return x * x;
}

[numthreads(1, 1, 1)]
void main()
{
    var dp = DifferentialPair<float>(a, 1.0);
    buf[0] = fwd_diff(sq)(dp).d;
}

// CHECK: [nameHint("sq.fwd_diff")]
// CHECK-NEXT: let {{.*}} = ForwardDifferentiate(%sq)
