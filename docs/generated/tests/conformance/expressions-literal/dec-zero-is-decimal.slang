//META: generated=true
//META: doc_ref=docs/language-reference/expressions-literal.md#integer-literal-expressions
//META: purpose=`0` alone is a decimal literal (not octal); the literal is valid as `int` and prints as 0 under the interpreter.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The reference's integer-literal-expressions grammar admits `0` as a
// stand-alone decimal literal body (the `DecIntegerLiteralBody` rule's
// first alternative). The "Note: `0` alone is decimal" caveat in the
// prose confirms this is not octal. Verify the value parses and prints
// as 0 under the interpreter.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 0;
    //CHECK: value=0
    printf("value=%d\n", x);
}
