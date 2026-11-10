//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=Negative probe: a `\u` escape with fewer than 4 hex digits is diagnosed as an invalid Unicode string escape (E10008).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the fixed-width rule of the `\u` escape form: the escape
// below provides only two hex digits before a non-hex character, so
// the ill-formed-Unicode-escape diagnostic fires, pinned to code
// E10008 with the digit-count requirement in its message.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    String s = "ab\u12xy";
    //CHECK: \u must be followed by 4 hex digits
    // CHECK: E10008
}
