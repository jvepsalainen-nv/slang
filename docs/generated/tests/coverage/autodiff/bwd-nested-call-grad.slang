//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/differentiation.md#reverse-mode
//META: purpose=Verifies bwd_diff differentiates through a nested call to another differentiable function, summing the chain-rule contributions.
//META: intent=characterization
//META: covers=source/slang/slang-ir-autodiff-transpose.cpp
//META: characterization-unverified=true
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization of reverse-mode transcription across a call boundary:
// f(x) = g(x) + x with g(x) = x*x, so df/dx = 2*x + 1; at x=3 that is 7.
// The transpose pass must emit and invoke g's backward propagator and add
// its contribution to the identity term. CHECK pins the CPU value. Tagged
// unverified: asserted against the compiler's own current CPU output.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

typedef DifferentialPair<float> dpfloat;

[Differentiable]
float g(float x)
{
    return x * x;
}

[Differentiable]
float f(float x)
{
    return g(x) + x;
}

//TEST_INPUT:ubuffer(data=[0], stride=4):out,name=outputBuffer
RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    dpfloat dp = dpfloat(3.0, 0.0);
    __bwd_diff(f)(dp, 1.0);
    outputBuffer[0] = dp.d;
}

// CHECK: 7.0
