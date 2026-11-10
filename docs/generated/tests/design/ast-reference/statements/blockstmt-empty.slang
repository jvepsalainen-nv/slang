//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#blockstmt-and-seqstmt
//META: purpose=An empty BlockStmt `{}` is accepted in statement position and has no observable effect; the surrounding state is preserved across the block.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the smallest block form — `{}` with no statements at all —
// is accepted in statement position and contributes nothing. The CHECK
// asserts a variable declared before the block still reads 42 after it,
// which holds only if the empty block parsed as a real statement and
// executed as a no-op.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 42;
    {
    }
    // CHECK: x=42
    printf("x=%d\n", x);
}
