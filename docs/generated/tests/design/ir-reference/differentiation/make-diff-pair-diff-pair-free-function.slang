//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#makediffpair
//META: purpose=The free function diffPair(primal, diff) is a second user spelling of MakeDiffPair and yields the same opcode as the DifferentialPair<T> constructor.
//META: intent=functional
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the claim that the construction opcode is reachable from ordinary
// user code through a second spelling — the core-module free function
// `diffPair(primal, diff)`. The pair is bound to a named local so the dump line
// carries the `nameHint("p")`; CHECK asserts that this named binding is a
// `MakeDiffPair(%a, %d)` value with the same `DiffPair(Float, ...)` result type
// the constructor spelling produces, which is what makes the two spellings
// interchangeable at IR level.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -dump-ir -o - -entry main -stage compute

uniform float a;
uniform float d;
uniform RWStructuredBuffer<float> buf;

[ForwardDifferentiable]
float f(float x)
{
    return x + x * x;
}

[numthreads(1, 1, 1)]
void main()
{
    DifferentialPair<float> p = diffPair(a, d);
    buf[0] = __fwd_diff(f)(p).d;
}

// CHECK: func %main
// CHECK: let %p{{.*}}DiffPair(Float, {{%[A-Za-z0-9_]+}}){{.*}}= MakeDiffPair(%a, %d)
