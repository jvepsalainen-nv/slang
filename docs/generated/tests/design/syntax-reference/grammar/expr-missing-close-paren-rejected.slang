//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#expressions
//META: purpose=A parenthesized expression atom requires a matching `)`; a missing close-paren is rejected.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `( Expr )` requires the closing paren. Omitting it
// causes a parse-stage diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    int x = (1 + 2;
    //CHECK: error
    //CHECK: E20001
    printf("x=%d\n", x);
}
