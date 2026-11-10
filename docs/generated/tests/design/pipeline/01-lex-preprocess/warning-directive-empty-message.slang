//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=Boundary probe of `#warning`: a bare `#warning` with no message text still fires the documented preprocessor-warning diagnostic.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#warning` with the empty message — the lower edge of the
// message axis. The warning diagnostic must still be emitted with
// nothing after `#warning:`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#warning
/*CHECK:
 ^^^^^^^ preprocessor warning
 ^^^^^^^ #warning:
*/
// CHECK: W15901

void main() {}
