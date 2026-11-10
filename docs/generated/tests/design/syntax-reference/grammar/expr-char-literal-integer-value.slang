//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#literal-forms-vs-token-kinds
//META: purpose=`CHAR_LIT` is a `Literal` that lowers to an `IntegerLiteralExpr` rather than a dedicated character node.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a character literal carries an integer value: 'A'
// converted with a constructor-style cast plus 1 prints 66, i.e. the
// code point 65 participated directly in integer arithmetic.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: v=66
    printf("v=%d\n", int('A') + 1);
}
