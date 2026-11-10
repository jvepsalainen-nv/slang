//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#ifstmt
//META: purpose=An IfStmt evaluates its predicate Expr exactly once per execution of the statement; a side-effecting predicate's effect is observed exactly once, regardless of which branch is selected.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: the IfStmt holds a single `predicate: Expr*` slot. If
// the checker mis-lowered the predicate into both the test and one
// of the branches, a side-effecting predicate would be observed
// twice. We use an inout counter argument as the side-effecting
// predicate (slangi cannot host non-const static module globals).

//TEST:INTERPRET(filecheck=CHECK):

bool predicate(inout int counter)
{
    counter = counter + 1;
    return true;
}

void main()
{
    int calls = 0;
    if (predicate(calls)) { calls = calls + 10; }
    // calls should be 1 (predicate) + 10 (branch) = 11
    // CHECK: calls=11
    printf("calls=%d\n", calls);
}
