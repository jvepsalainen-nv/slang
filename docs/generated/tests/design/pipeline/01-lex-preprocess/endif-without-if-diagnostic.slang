//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#failure-modes
//META: purpose=A #endif with no open conditional is diagnosed as its own error (DirectiveWithoutIf), separate from the unclosed-conditional diagnostic.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The stray closer is a separate diagnostic from the end-of-file
// "unclosed conditional" one.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#endif
/*CHECK:
 ^^^^^ 'endif' directive without '#if'
*/

void main() {}
