//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`LabelStmt ::= IDENT ':' Stmt` names a loop that the `IDENT` arm of `BreakStmt ::= 'break' IDENT? ';'` then exits.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the two halves of the labeled-break story together: an
// identifier followed by `:` in statement position labels the loop
// that follows it, and `break <label>;` targets that outer loop rather
// than the innermost one. The counter distinguishes the two readings:
// an unlabeled break would leave the outer loop running for all three
// iterations and reach 3, while breaking out of `outer` stops the
// whole nest on the first pass.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int passes = 0;
    outer:
    for (int i = 0; i < 3; ++i)
    {
        passes += 1;
        for (int j = 0; j < 3; ++j)
        {
            if (j == 1) break outer;
        }
    }
    // CHECK: passes=1
    printf("passes=%d\n", passes);
}
