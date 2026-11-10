//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#trivia-whitespace-and-comments
//META: purpose=Boundary - an empty block comment (`/**/`) is a valid BlockComment token and is removed from the token stream.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: zero-content block comment must be accepted by
// the lexer. The expression `1 + /**/ 2` must parse as `1 + 2`.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = 1 + /**/ 2;
    // CHECK: v=3
    printf("v=%d\n", v);
}
