//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#ifstmt
//META: purpose=An IfStmt's negativeStatement slot is null for an `if` without an `else`; when the predicate is false the program continues with no side effects from the missing else branch.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies an `if` written without an `else` simply does nothing when
// the predicate is false — there is no alternative branch to run. The
// CHECKs assert the variable keeps its prior value after a false
// predicate and is updated after a true one.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 7;
    if (1 == 2) { x = 99; }
    // CHECK: x-after-false=7
    printf("x-after-false=%d\n", x);

    if (1 == 1) { x = 42; }
    // CHECK: x-after-true=42
    printf("x-after-true=%d\n", x);
}
