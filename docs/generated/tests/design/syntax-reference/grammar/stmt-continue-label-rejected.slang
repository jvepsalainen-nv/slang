//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#statements
//META: purpose=`ContinueStmt` parses as `'continue' ';'` with no optional label, unlike `BreakStmt`; a labeled continue is rejected.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the asymmetry the production calls out: BreakStmt admits an
// optional IDENT label but ContinueStmt does not. An identifier after
// `continue` must trigger the parser's unexpected-token diagnostic
// E20001 where a `;` was required.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    for (int i = 0; i < 4; i++)
    {
        continue again;
        //CHECK: error
        //CHECK: E20001
    }
}
