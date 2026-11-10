//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#forward-mode
//META: purpose=[HasTrivialForwardDerivative] is the second attribute whose synthesized fwd_diff member is built from TrivialForwardDifferentiate rather than ForwardDifferentiate.
//META: intent=expansion
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second of the two attributes the `TrivialForwardDifferentiate`
// row names as its origin; `trivial-forward-differentiate.slang` covers the
// `[TreatAsDifferentiable]` branch. The surface `__fwd_diff(g)` is identical in
// both, so the attribute is the only variable. CHECK requires the synthesized
// member to be produced by `TrivialForwardDifferentiate(%g)` with the JVP
// function type over differential pairs, and forbids the non-trivial
// `ForwardDifferentiate(%g)` spelling anywhere in the LOWER-TO-IR section —
// the pair of assertions is what separates this row from the ordinary
// forward-mode one, since both produce a member with the same name and type.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float a;
uniform float d;
uniform RWStructuredBuffer<float> buf;

[HasTrivialForwardDerivative]
float g(float x)
{
    return x * x;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = __fwd_diff(g)(DifferentialPair<float>(a, d)).d;
}

// CHECK: {{^}}### LOWER-TO-IR:
// CHECK: let {{%[A-Za-z0-9_]+}} : Func(DiffPair(Float, {{%[A-Za-z0-9_]+}}), DiffPair(Float, {{%[A-Za-z0-9_]+}})) = TrivialForwardDifferentiate(%g)
// CHECK-NOT: = ForwardDifferentiate(%g)
// CHECK: {{^}}###{{$}}
