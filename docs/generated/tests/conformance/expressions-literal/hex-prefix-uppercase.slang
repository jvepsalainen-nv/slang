//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=Hexadecimal prefix is case-insensitive: `0X` (uppercase) parses identically to `0x` (lowercase).
//META: intent=boundary
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's `HexIntegerLiteralBody` production explicitly lists
// `('0x' | '0X')` as the prefix alternatives. Verify the uppercase
// prefix accepts a hex literal that equals its lowercase counterpart.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int lower = 0xff;
    int upper = 0XFF;
    //CHECK: lower=255 upper=255 eq=1
    printf("lower=%d upper=%d eq=%d\n", lower, upper, lower == upper ? 1 : 0);
}
