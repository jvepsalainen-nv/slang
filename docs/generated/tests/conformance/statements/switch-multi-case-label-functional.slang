//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#switch-statement
//META: purpose=A single switch case clause may be reached by multiple case labels stacked before a single body.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a single case clause can be reached by multiple case labels.
// The doc example shows `case 0: case 1: doBasicThing(); break;` — both labels share body.
//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0 0], stride=4)

int multicase(int v)
{
    int result = 0;
    switch (v)
    {
    case 0:
    case 1:
        result = 42;
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
    outputBuffer[0] = multicase(0);
    outputBuffer[1] = multicase(1);
    outputBuffer[2] = multicase(2);
}

//CHECK: 42
//CHECK: 42
//CHECK: -1
