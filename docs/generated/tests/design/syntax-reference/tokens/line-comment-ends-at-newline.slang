//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#trivia-whitespace-and-comments
//META: purpose=A `LineComment` (`// ...`) ends at the end of its physical line; code on the following line is not part of the comment.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `//` comments terminate at the newline. The
// declaration `int x = 9;` on the line *after* the `//` comment must
// still be parsed and produce the expected value.

//TEST:INTERPRET(filecheck=CHECK):

// this comment ends here; the next line is real code
static const int x = 9;

void main()
{
    // CHECK: x=9
    printf("x=%d\n", x);
}
