//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#declstmt-expressionstmt-and-emptystmt
//META: purpose=A `;` as the else branch of an `if` also yields an EmptyStmt and the potentially-unintended-empty-statement warning, because the parent statement is an IfStmt for either branch.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the warning fires for `else ;` and not for `else {}`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x == 0) outputBuffer[0] = 1; else ;
//CHECK:                                      ^ potentially unintended empty statement
//CHECK:                                      ^ potentially unintended empty statement at this location; use {} instead.
    if (tid.x == 0) {} else {}
}
