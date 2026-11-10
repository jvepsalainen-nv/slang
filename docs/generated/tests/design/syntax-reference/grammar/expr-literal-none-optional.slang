//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#literal-forms-vs-token-kinds
//META: purpose=`none` is recognized as a `Literal` atom (NoneLiteralExpr) usable to initialize an Optional value.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `none` literal: initializing an Optional<int> with it
// yields an absent value (hasValue false), and reassigning a real
// value flips it — so `none` must have parsed as the none-literal
// atom, not as a name lookup.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name=outputBuffer

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    Optional<int> o = none;
    // CHECK: 0
    outputBuffer[0] = o.hasValue ? 1 : 0;
    o = 5;
    // CHECK: 5
    outputBuffer[1] = o.hasValue ? o.value : -1;
}
