//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#type-queries-and-predicates
//META: purpose=A scalar type predicate applied to a vector or matrix answers for that type's element type, so `__isFloat<float3>()` and `__isFloat<float3x3>()` are both true.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the element-unwrapping rule at the composite boundary: the fold
// strips a vector or matrix down to its element type before applying the
// predicate. The mask combines the true cases (`float3`, `float3x3`, `int4`)
// with the false case that proves the unwrap did not simply answer "yes" for
// every composite — an integer vector must not report as floating point.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int mask = 0;
    if (__isFloat<float3>()) mask |= 1;
    if (__isFloat<float3x3>()) mask |= 2;
    if (__isInt<int4>()) mask |= 4;
    if (__isInt<int2x2>()) mask |= 8;
    if (!__isInt<float3>() && !__isFloat<int4>()) mask |= 16;
    outputBuffer[0] = mask;
}

// CHECK: 31
