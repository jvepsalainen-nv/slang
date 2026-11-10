//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=Negative probe: an empty character literal is diagnosed at decode time as an illegal character literal (E10001).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "body too short to hold a character" arm of the
// one-character rule that the char value-extraction helper owns. The
// scanner only finds the closing quote; the rejection happens when
// the value is decoded, so the diagnostic is pinned to E10001 with a
// caret spanning the two quotes the scanner recorded.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    uint c = '';
//CHECK:     ^^ illegal character literal
// CHECK: E10001
}
