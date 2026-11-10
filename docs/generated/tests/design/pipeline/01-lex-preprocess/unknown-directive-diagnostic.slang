//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#failure-modes
//META: purpose=An unknown preprocessor directive emits a diagnostic through the DiagnosticSink.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the preprocessor reports an "unknown directive"
// diagnostic for `#`-introduced names that are not in the directive
// callback table.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#not_a_real_directive
/*CHECK:
 ^^^^^^^^^^^^^^^^^^^^ unknown directive
 ^^^^^^^^^^^^^^^^^^^^ unknown preprocessor directive 'not_a_real_directive'
*/
// CHECK: E15101

void main() {}
