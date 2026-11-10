//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#forward-mode
//META: purpose=A trivial forward derivative runs the primal and returns zero output differentials, ignoring the incoming tangents.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the behavioural half of the `TrivialForwardDifferentiate` row. The
// sibling IR tests assert only which opcode is built; this one runs the result
// and shows what the opcode *means*. Both spellings that select the trivial
// derivative are exercised on the same body `x * x`, differentiated at x = 3
// with an incoming tangent of 1. The primal is 9 in both cases, so the primal
// really is evaluated; the differential is 0 rather than the true 6, which is
// what "returns zero output differentials, ignoring incoming tangents" means —
// a non-zero incoming tangent produced no output tangent.

//TEST:INTERPRET(filecheck=CHECK):

[TreatAsDifferentiable]
float treatAs(float x) { return x * x; }

[HasTrivialForwardDerivative]
float trivialFwd(float x) { return x * x; }

void main()
{
    DifferentialPair<float> r0 = __fwd_diff(treatAs)(DifferentialPair<float>(3.0, 1.0));
    DifferentialPair<float> r1 = __fwd_diff(trivialFwd)(DifferentialPair<float>(3.0, 1.0));

    // Primal is the ordinary result of the body; differential is zeroed.
    printf("treatAs p=%f d=%f\n", r0.p, r0.d);
    printf("trivialFwd p=%f d=%f\n", r1.p, r1.d);
}

// CHECK: treatAs p=9.000000 d=0.000000
// CHECK: trivialFwd p=9.000000 d=0.000000
