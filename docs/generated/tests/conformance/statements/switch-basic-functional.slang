//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#switch-statement
//META: purpose=switch routes to the matching case label; default fires when no case matches.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that switch dispatches to the matching case and that default fires for no-match.
// Uses COMPARE_COMPUTE -cpu because switch inside a helper function crashes slangi (bug).
//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0 0], stride=4)

int describe(int v)
{
    int result = 0;
    switch (v)
    {
    case 0:
        result = 100;
        break;
    case 1:
        result = 200;
        break;
    default:
        result = -1;
        break;
    }
    return result;
}

RWStructuredBuffer<int> outputBuffer;

[numthreads(1,1,1)]
void computeMain()
{
    outputBuffer[0] = describe(0);
    outputBuffer[1] = describe(1);
    outputBuffer[2] = describe(99);
}

//CHECK: 100
//CHECK: 200
//CHECK: -1
