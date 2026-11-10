//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#token-flags
//META: purpose=A folded `\\`-newline emits no `NewLine` token, so the token after it is not marked as starting a logical line and a macro body can span two physical lines.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the interaction the `AtStartOfLine` flag exists for: the
// preprocessor ends a directive at the first token that starts a logical line,
// and a folded continuation must not create one. The macro body lives on the
// physical line after the backslash; if that line had been flagged as a line
// start, the body would have been dropped from the definition and the
// expansion would not compute 42.

//TEST:INTERPRET(filecheck=CHECK):

#define BUMP(x) \
    ((x) + 1)

void main()
{
    // CHECK: bump=42
    printf("bump=%d\n", BUMP(41));
}
