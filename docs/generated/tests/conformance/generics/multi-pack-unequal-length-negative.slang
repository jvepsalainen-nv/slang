//META: generated=true
//META: doc_ref=docs/language-reference/generics.md#type-parameter-packs-type-param-packs
//META: purpose=Two expand/each parameters that draw from the same pack cannot be bound to argument lists of unequal length.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the equal-length requirement for multiple expand/each parameters.
// `dotProduct` declares two parameters expanding the same pack `T`, so any call
// must split its arguments into two equal halves. Passing five arguments admits
// no such split. CHECK asserts E30438 fires at the call, proving the compiler
// refuses to specialize the two packs at unequal lengths.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl

void dotHelper(float a, float b, inout float ret)
{
    ret += a * b;
}

float dotProduct<each T>(expand each T a, expand each T b) where T == float
{
    float r = 0.0f;
    expand dotHelper(each a, each b, r);
    return r;
}

RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = dotProduct(1.0f, 2.0f, 3.0f, 4.0f, 5.0f);
    //CHECK: E30438
}
