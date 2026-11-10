//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=`AtomExpr` accepts a parenthesized expression `'(' Expr ')'` and the parens override precedence.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the parenthesized `AtomExpr` production. Without parens,
// `2 + 3 * 4` is 14; with the parens regrouping, `(2 + 3) * 4` is
// 20 — confirming both that the `(Expr)` form parses and that it
// forces the inner grouping.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int r = (2 + 3) * 4;
    // CHECK: r=20
    printf("r=%d\n", r);
}
