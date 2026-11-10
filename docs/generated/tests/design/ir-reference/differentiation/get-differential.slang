//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#differential-pair-projection
//META: purpose=The .d getter of DifferentialPair<T> lowers to GetDifferential on the pair, producing the differential element type.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the differential half of the projection table: reading `.d` off a
// `DifferentialPair<float>` returned by a forward-differentiated call emits
// `GetDifferential`, whose result type is the differential type of `float` —
// `Float` again, since the scalar is its own differential. CHECK is anchored
// after `func %main` so the many `GetDifferential` uses in the core-module
// autodiff preamble cannot satisfy the pattern.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float a;
uniform float d;
uniform RWStructuredBuffer<float> buf;

[ForwardDifferentiable]
float f(float x)
{
    return x * x;
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = __fwd_diff(f)(DifferentialPair<float>(a, d)).d;
}

// CHECK: func %main
// CHECK: Float{{.*}}= GetDifferential(
