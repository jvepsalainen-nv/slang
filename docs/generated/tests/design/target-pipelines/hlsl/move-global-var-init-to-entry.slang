//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-c-hlsl-legalization-lowering-phi-elimination
//META: purpose=A `static` module-scope variable retains its `static T name = initial;` declaration in HLSL emit.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per the doc Phase C, HLSL/GLSL/WGSL hit
// `moveGlobalVarInitializationToEntryPoints`. For a simple
// compile-time-constant initializer, the HLSL emit keeps the
// declaration with an inline initializer (the pass is a no-op
// for this shape because the constant literal is already legal
// at module scope).

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

static int g_counter = 42;
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    outBuf[0] = g_counter;
}

// CHECK: static int g_counter_{{[0-9]+}} = int(42)
// CHECK: void main(
// CHECK: outBuf_{{[0-9]+}}[{{.*}}] = g_counter_{{[0-9]+}};
