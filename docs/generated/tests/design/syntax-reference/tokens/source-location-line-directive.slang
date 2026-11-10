//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/tokens.md#source-location
//META: purpose=A token's nominal source location honours `#line`, so `__LINE__` after `#line 100` reports 100 rather than the physical line.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `Nominal` interpretation of a token's `SourceLoc` is the one the
// preprocessor exposes. `__LINE__` is the only user-visible read of that
// decoded location, so printing it directly after a `#line` directive shows
// whether the directive was honoured; a physical-line ("Actual") reading would
// print this file's real line number instead.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: line=100
#line 100
    printf("line=%d\n", __LINE__);
}
