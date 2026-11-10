//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#switch-statement
//META: purpose=A switch statement with only a default label fires the default for any value.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a switch with only a default label: all values hit default.
// Uses COMPARE_COMPUTE -cpu since slangi does not support switch in called functions.
//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0], stride=4)

int defaultOnly(int v)
{
    int result = 0;
    switch (v)
    {
    default:
        result = 77;
        break;
    }
    return result;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
{
    outputBuffer[0] = defaultOnly(0);
    outputBuffer[1] = defaultOnly(999);
}

//CHECK: 77
//CHECK: 77
