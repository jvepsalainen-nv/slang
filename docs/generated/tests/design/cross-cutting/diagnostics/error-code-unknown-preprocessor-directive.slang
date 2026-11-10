//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=An unknown preprocessor directive renders E15101 with the directive name interpolated.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `unknown-preprocessor-directive` (15101) to its rendered
// code. `~directive` is the interpolated offending directive name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#thisisbogus
/*CHECK:
 ^^^^^^^^^^^ E15101
 ^^^^^^^^^^^ unknown preprocessor directive 'thisisbogus'
*/
void main() {}
