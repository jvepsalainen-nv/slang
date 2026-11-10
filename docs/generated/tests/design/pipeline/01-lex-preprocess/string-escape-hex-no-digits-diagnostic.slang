//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#literal-scanning-and-value-extraction
//META: purpose=Negative probe: a `\x` escape with no hex digits is diagnosed as an invalid string escape (E10007).
//META: intent=negative
//META: pipeline_stage=lex
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower edge of the "any number of digits" rule for
// `\x`: at least one hex digit is required, so an `\x` immediately
// followed by non-hex characters is an ill-formed escape, pinned to
// code E10007.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    String s = "ab\xzy";
    //CHECK: invalid string escape: '\x'
    // CHECK: E10007
}
