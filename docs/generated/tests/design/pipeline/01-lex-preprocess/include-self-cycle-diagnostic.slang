//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#failure-modes
//META: purpose=Negative probe: a `#include` of the file itself triggers the documented "cyclic include" preprocessor diagnostic.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Self-include cycle: this file includes itself by name. The
// preprocessor must detect the cycle and emit the cyclic-include
// diagnostic instead of recursing forever.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

#include "include-self-cycle-diagnostic.slang"
//CHECK: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ cyclic include
//CHECK: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ cyclic `#include` of file '"include-self-cycle-diagnostic.slang"'
// CHECK: E15302

void main() {}
