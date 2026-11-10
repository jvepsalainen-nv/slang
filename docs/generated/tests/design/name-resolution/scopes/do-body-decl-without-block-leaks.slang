//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A declaration used directly as a `do` body — with no braces — is accepted rather than rejected, and the name leaks into the enclosing scope.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the third shape of the brace-less-body rule. A `do` body runs at
// least once, so the declaration's initializer executes, and because
// `DoWhileStmt` gets no fresh ScopeDecl the declaration lands in the
// enclosing function's container. Printing `y=5` after the loop shows both
// halves: the name is still bound after the statement, and it is bound to
// the declaration written as the loop body.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int c = 0;
    do int y = 5; while (c > 0);
    // CHECK: y=5
    printf("y=%d\n", y);
}
