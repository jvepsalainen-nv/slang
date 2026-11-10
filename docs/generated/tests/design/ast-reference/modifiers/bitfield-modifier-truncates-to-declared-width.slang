//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=A C-style bitfield member stores only its declared width, so a wider assigned value is truncated on read-back.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a bitfield declaration is a real width constraint on the member's
// storage, not documentation. `a` is three bits signed and `b` is five bits
// unsigned; the test writes the first value that does not fit each (7 into a
// signed 3-bit field, 33 into a 5-bit field) and CHECK asserts the read-back
// values -1 and 1 -- the truncated, sign-extended results. Un-narrowed storage
// would return 7 and 33 instead.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT:ubuffer(data=[0 0], stride=4):out,name=outBuf
RWStructuredBuffer<int> outBuf;

struct Bits
{
    int a : 3;
    uint b : 5;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain()
{
    Bits x;
    x.a = 7;
    x.b = 33;
    outBuf[0] = x.a;
    outBuf[1] = int(x.b);
}
//CHECK: -1
//CHECK: 1
