//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#declstmt-expressionstmt-and-emptystmt
//META: purpose=An EmptyStmt gives a concrete statement for an empty slot; a loop whose body is a bare `;` is accepted and iterates via its side-effect expression alone.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a loop body consisting of only `;` is a valid statement
// slot: all iteration work happens in the for-header, the body is a
// bare semicolon, and the loop still runs to completion. The CHECK
// asserts the counter advanced through every iteration, which is only
// possible if the empty body parsed as a real statement and the loop
// executed normally.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int n = 0;
    for (; n < 4; n = n + 1)
        ;
    // CHECK: n=4
    printf("n=%d\n", n);
}
