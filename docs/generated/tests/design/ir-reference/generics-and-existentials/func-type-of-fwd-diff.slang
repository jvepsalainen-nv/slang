//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/generics-and-existentials.md#dispatchers-and-existential-specialization
//META: purpose=A func-dependent derivative type lowers to FuncTypeOf(callable) — a Type-valued projection that names a callable without embedding it.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.
// Verifies the compile-time projection a func-dependent type uses. Calling
// `fwd_diff` on a `[Differentiable]` function makes the derivative's type
// depend on the original callable, and lowering names that callable through a
// projection instead of embedding it. The CHECK asserts the projection's result
// is a `Type`.
//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float inVal;
uniform RWStructuredBuffer<float> buf;

[Differentiable]
float square(float x) { return x * x; }

[numthreads(1, 1, 1)]
void main()
{
    var dp = fwd_diff(square)(DifferentialPair<float>(inVal, 1.0));
    buf[0] = dp.d;
}

// CHECK: let  %{{[0-9]+}} : Type = FuncTypeOf(%{{[A-Za-z0-9_]+}})
