//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=The standard C/HLSL `#error` directive is supported and causes the preprocessor to emit a diagnostic with the directive's message text.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `#error MSG` triggers a preprocessor diagnostic
// whose text contains the message body. We surround the `#error`
// with `#if 1` so the diagnostic is reached, and FileCheck the
// emitted diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#if 1
#error This is the error message!
/*CHECK:
 ^^^^^ preprocessor error
 ^^^^^ #error: This is the error message!
*/
// CHECK: E15900
#endif

void main() {}
