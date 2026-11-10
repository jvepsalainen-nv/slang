//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#synthesized-derivative-witnesses
//META: purpose=Without -experimental-feature a user-code __func_extension declaration draws the 30131 gate warning (a warning, not an error) and the declaration is dropped.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the gate on the only user surface that produces `IdentityRemat`.
// The companion test `identity-remat.slang` compiles the same shape *with*
// `-experimental-feature`; this file compiles it without, and asserts that
// checking diagnoses the declaration with a warning. The caret is on the `__apply` token of the
// `__func_extension` declaration and carries E30131, which is what pins the
// gate to the declaration itself rather than to the later use. It is a warning,
// not an error: the entry point still compiles (exit code 0), so the
// diagnostic is the only evidence the extension was dropped; the companion
// `func-extension-dropped-declaration-fails-use.slang` shows the later failure.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

uniform float a;
uniform RWStructuredBuffer<float> buf;

float sqr(float x) { return x * x; }

struct SqrContext
{
    float cached;
    void operator()(out float dx, float dOut) { dx = dOut * cached; }
};

__func_extension __apply(sqr)(float x) -> Tuple<float, SqrContext>
//CHECK:         ^^^^^^^ E30131
//CHECK:         ^^^^^^^ __func_extension declarations are rejected unless '-experimental-feature' is enabled.
{
    return makeTuple(x * x, SqrContext(2.0 * x));
}

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = sqr(a);
}
