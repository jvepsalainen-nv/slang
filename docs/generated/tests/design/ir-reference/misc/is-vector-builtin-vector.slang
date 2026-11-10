//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/misc.md#type-queries-and-predicates
//META: purpose=`__isVector<T>()` is true for a builtin vector and false for a scalar or a matrix, because the fold classifies the operand type itself rather than its element type.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `IsVector` against the other predicates' element-unwrapping rule.
// Each shape writes its own buffer slot so a wrong answer for any one shape is
// visible: a scalar and a matrix are not vectors, while two- and four-component
// vectors (including an integer vector) are.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type

//TEST_INPUT:ubuffer(data=[9 9 9 9 9], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = __isVector<float>() ? 1 : 0;
    outputBuffer[1] = __isVector<float2>() ? 1 : 0;
    outputBuffer[2] = __isVector<int4>() ? 1 : 0;
    outputBuffer[3] = __isVector<float2x2>() ? 1 : 0;
}

// CHECK: 0
// CHECK-NEXT: 1
// CHECK-NEXT: 1
// CHECK-NEXT: 0
