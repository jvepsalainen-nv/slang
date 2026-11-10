//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=Hex digits A-F are case-insensitive per the `HexDigit = <[0-9A-Fa-f]>` production; `0xABCD` and `0xabcd` parse to the same value.
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's `HexDigit` non-terminal admits both upper- and
// lower-case A-F. Verify both spellings parse to the same integer.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int u = 0xABCD;
    int l = 0xabcd;
    int m = 0xAbCd;
    //CHECK: u=43981 l=43981 m=43981 eq=1
    printf("u=%d l=%d m=%d eq=%d\n", u, l, m, (u == l && l == m) ? 1 : 0);
}
