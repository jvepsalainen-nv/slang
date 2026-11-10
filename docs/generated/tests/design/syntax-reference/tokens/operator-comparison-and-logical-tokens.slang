//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#operators
//META: purpose=Each multi-character comparison / logical / increment spelling (`<<`, `>>`, `==`, `!=`, `>=`, `<=`, `&&`, `\|\|`, `++`, `--`) lexes as one operator token.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies maximal-munch lexing for the non-assigning multi-character
// operators. Each pair would otherwise read as two single-character operators
// with a completely different meaning (`&&` as address-of-address-of, `++` as
// unary plus twice). The operand comes from the dispatch thread id so the
// comparisons survive to run time, and the single summed buffer value only
// arises if every spelling lexed as one token.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-cpu -output-using-type
//TEST_INPUT: set outputBuffer = out ubuffer(data=[0], stride=4)
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int a = int(tid.x) + 5;           // 5
    int b = (a << 2) >> 1;            // 10
    bool p = (a == 5) && (b != 0);    // true
    bool q = (a >= 5) || (b <= 0);    // true
    int c = 0;
    if (p && q) { c++; }              // 1
    c--;                              // 0
    ++c;
    ++c;                              // 2
    outputBuffer[0] = b + (p ? 100 : 0) + (q ? 1000 : 0) + c;
    // CHECK: 1112
}
