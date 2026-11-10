//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#special-case-lexing-rules
//META: purpose=Boundary - backslash-line-continuation runs before lexing, so a `\<newline>` at the end of a `//` line splices the following physical line into the comment and the line is consumed by it.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary probe: the line-continuation rule is applied before the
// lexer recognizes `//`-comment boundaries. A `\` at the end of a
// comment line therefore swallows the *next* physical line. The
// declaration `int swallowed = 0;` directly below the comment is
// consumed; only the line after it (`real`) becomes a real
// declaration that `main` can print.

//TEST:INTERPRET(filecheck=CHECK):

// this comment continues with a backslash \
int swallowed = 0;
static const int real = 21;

void main()
{
    // CHECK: real=21
    printf("real=%d\n", real);
}
