//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A `#error` directive renders the preprocessor-range code E15900 with the user message interpolated.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `user-defined-error` (15900) to its rendered code. The
// directive's payload is interpolated via `~message`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#error "custom preprocessor error"
/*CHECK:
 ^^^^^ E15900
 ^^^^^ #error: "custom preprocessor error"
*/
void main() {}
