//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#failure-modes
//META: purpose=A `#if` directive with no matching `#endif` is reported as a preprocessor diagnostic.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the preprocessor reports the unbalanced `#if` /
// `#endif` failure mode. The opening `#if 1` below has no matching
// `#endif`; the preprocessor must emit a diagnostic at end-of-file
// referring to the open conditional.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#if 1
/*CHECK:
 ^^ see 'if' directive
*/
void main() {}
//CHECK: end of file encountered during preprocessor conditional
// CHECK: E15000
