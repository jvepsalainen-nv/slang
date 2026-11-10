//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#empty-statement
//META: purpose=A lone semicolon is a valid empty statement; used as for-loop body with zero iterations.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a lone `;` is accepted as an empty statement in a for-loop body position.
// The loop counts to N using `;` as the body; the update variable tracks loop progress.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int i;
    // Empty statement as for-loop body: loop completes, i reaches 5
    for (i = 0; i < 5; i++);
    // CHECK: 5
    printf("%d\n", i);
}
