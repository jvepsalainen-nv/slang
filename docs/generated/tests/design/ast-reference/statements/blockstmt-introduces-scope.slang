//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#blockstmt-and-seqstmt
//META: purpose=A BlockStmt is a ScopeStmt; a local declared inside `{ ... }` is not visible outside the block, so a same-named outer variable retains its outer value after the block closes.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The documented role of BlockStmt is that it introduces a new lexical
// scope via its ScopeDecl. We observe this by declaring a local with
// the same name inside a `{}` block: assigning to the inner local must
// not affect the outer same-named variable, because the inner name
// shadows but does not refer to the outer storage.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 1;
    {
        int x = 99;
        x = x + 1;
    }
    // CHECK: x=1
    printf("x=%d\n", x);
}
