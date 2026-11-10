//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=Binary integer literal: prefix `0b` followed by `0`/`1` digits parses to the documented value; `0b1010` is decimal 10.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's `BinIntegerLiteralBody` production specifies
// prefix `'0b' | '0B'` followed by `BinDigit+` (`0` or `1`). Verify
// the parsed value matches the documented binary semantics.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0b1010;
    int y = 0B1111;
    //CHECK: x=10 y=15
    printf("x=%d y=%d\n", x, y);
}
