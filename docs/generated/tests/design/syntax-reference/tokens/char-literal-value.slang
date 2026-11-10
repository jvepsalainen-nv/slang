//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#content-tokens
//META: purpose=A single-quoted character literal (`CharLiteral`) is recognized by the lexer and carries the character's integer code-point value.
//META: intent=functional
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the char literal `'A'` evaluates to the ASCII code for
// 'A' (65). The claim under test is that the lexer recognizes the
// single-quoted form; the value 65 is the documented ASCII mapping.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: code=65
    printf("code=%d\n", int('A'));
}
