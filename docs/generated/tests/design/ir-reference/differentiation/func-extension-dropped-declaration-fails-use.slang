//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#synthesized-derivative-witnesses
//META: purpose=Without -experimental-feature the __func_extension declaration is dropped after its warning, and the compile fails later on a separate error at whatever referred to it.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second half of the gate described under the synthesized
// derivative witnesses: the declaration is dropped, so the compile does not
// stop at the warning but fails on the use that depended on it. The shader is
// the one from `func-extension-requires-experimental-feature.slang` plus a
// `bwd_diff(sqr)` call, which can only resolve through the dropped extension.
// CHECK pins the warning code first, then the later error code, so the test
// cannot pass on an unrelated failure; the directive expects exit code -1.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

uniform float a;
uniform RWStructuredBuffer<float> buf;

float sqr(float x) { return x * x; }

struct SqrContext
{
    float cached;
    void operator()(out float dx, float dOut) { dx = dOut * cached; }
};

__func_extension __apply(sqr)(float x) -> Tuple<float, SqrContext>
{
    return makeTuple(x * x, SqrContext(2.0 * x));
}

[numthreads(1, 1, 1)]
void main()
{
    var dpx = diffPair(a, 0.0);
    bwd_diff(sqr)(dpx, 1.0);
    buf[0] = dpx.d;
}

// CHECK: 30131
// CHECK: E30027
