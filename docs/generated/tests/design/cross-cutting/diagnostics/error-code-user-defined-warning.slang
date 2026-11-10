//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A `#warning` directive renders the preprocessor-range code E15901 with the user message interpolated.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `user-defined-warning` (15901) to its rendered code. The
// directive's payload is interpolated via `~message`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#warning "custom preprocessor warning"
/*CHECK:
 ^^^^^^^ E15901
 ^^^^^^^ #warning: "custom preprocessor warning"
*/
void main() {}
