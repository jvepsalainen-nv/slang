//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=Negative - an integer literal followed by a non-documented suffix (`xyz`) triggers the "invalid suffix on integer literal" diagnostic.
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative probe: the doc says suffix characters like `u`, `l`, `f`,
// `h` are part of the literal token; an unrecognized suffix
// (`xyz`) must be rejected with an explicit diagnostic from the
// checker.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = 1xyz;
//CHECK:    ^^^^ invalid suffix on integer literal
//CHECK:    ^^^^ invalid suffix 'xyz' on integer literal
}
