//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#literal-forms-vs-token-kinds
//META: purpose=`Literal ::= STRING_LIT+` — adjacent string-literal tokens fuse into a single string literal.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `+` repetition on STRING_LIT. Three adjacent literal
// tokens are written where one format string is expected; if they were
// three separate atoms the call would not type-check as a single
// format argument, and the printed text would not be the concatenation.
// Observing `abcd` on one line proves the tokens fused into one literal
// whose trailing newline came from the third token.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: abcd
    printf("ab" "cd" "\n");
}
