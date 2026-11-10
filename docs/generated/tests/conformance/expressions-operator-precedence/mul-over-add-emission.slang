//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=CPU compute kernel verifies `*` binds before `+`: buffer reads at runtime defeat constant folding; `a + b * c` with [2,3,4] yields 14.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Compute-dispatch version of the mul-over-add precedence claim.
// Uses a buffer to feed operands at runtime, defeating constant folding,
// so the generated code must actually perform `a + (b * c)` at dispatch.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT: set outputBuffer = out ubuffer(data=[2 3 4 0], stride=4)

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    int a = outputBuffer[0];
    int b = outputBuffer[1];
    int c = outputBuffer[2];
    outputBuffer[3] = a + b * c;  // must be 2 + (3*4) = 14
}

// CHECK: 2
// CHECK: 3
// CHECK: 4
// CHECK: 14
