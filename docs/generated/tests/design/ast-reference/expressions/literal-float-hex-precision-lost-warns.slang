//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=A hexadecimal float literal whose significand does not fit the suffix type is reported as warning E40019 and the truncated value is what lands in the literal.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the third of the three literal diagnostics, the one that is about
// precision rather than magnitude: the value is in range, but the hex
// significand carries more bits than a `float` has. The parser does not round
// silently and it does not reject the program either - it warns and keeps the
// truncated conversion. CHECK pins E40019 on the literal.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target hlsl -stage compute -entry computeMain

RWStructuredBuffer<float> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = 0x1.123456789abcdefp0f;
//CHECK:              ^^^^^^^^^^^^^^^^^^^^^^ E40019
}
