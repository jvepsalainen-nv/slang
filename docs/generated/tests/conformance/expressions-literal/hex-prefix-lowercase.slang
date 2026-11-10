//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=Hexadecimal integer literal: prefix `0x` followed by hex digits parses to the documented value; `0xFFFFFFFF` reads as the unsigned 32-bit all-ones pattern.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's `HexIntegerLiteralBody` production specifies prefix
// `'0x' | '0X'` followed by one or more `HexDigit`. Per the
// suffix/value table, an unsuffixed hex literal in `[0x80000000,
// 0xFFFFFFFF]` has type `uint`. Verify the bit pattern.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    uint x = 0xFFFFFFFF;
    //CHECK: value=4294967295
    printf("value=%u\n", x);
}
