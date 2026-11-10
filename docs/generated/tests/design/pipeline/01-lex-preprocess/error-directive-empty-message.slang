//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=Boundary probe of `#error`: a bare `#error` with no message text still fires the documented preprocessor error.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `#error` with the empty message — the lower edge of the message
// axis. The diagnostic must still be produced; its formatted text
// just has nothing after `#error:`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#error
/*CHECK:
 ^^^^^ preprocessor error
 ^^^^^ #error:
*/
// CHECK: E15900

void main() {}
