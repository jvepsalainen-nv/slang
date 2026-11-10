//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#declstmt-expressionstmt-and-emptystmt
//META: purpose=A `;` immediately after an `if` is suspicious rather than illegal: it still yields an EmptyStmt, but the compiler reports the potentially-unintended-empty-statement warning.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the empty statement in `if (cond);` is accepted (it is still
// a real statement slot) yet flagged. The CHECK pins the W20101
// warning the compiler reports at the semicolon; because the program
// compiles rather than erroring, the diagnostic is the only observable
// difference from any other empty statement.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x == 0);
//CHECK:           ^ potentially unintended empty statement
//CHECK:           ^ potentially unintended empty statement at this location; use {} instead.
    outputBuffer[0] = 1;
}
