//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#punctuation-and-structural-symbols
//META: purpose=The two-character spelling `=>` lexes as a single `DoubleRightArrow` token, whose only consumer is lambda syntax.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `=>` is one token rather than `OpAssign` followed by `OpGreater`.
// The lambda is passed through an `IFunc`-constrained helper (direct lambda
// invocation is not supported on the interpreter), and the buffer receives the
// lambda's result; a two-token reading would be an assignment to a comparison
// and could not have produced 42.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

TResult apply<TResult, TFunc : IFunc<TResult, int>>(TFunc f, int arg)
{
    return f(arg);
}

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = apply((int x) => x * 3, 14);
    // CHECK: 42
}
