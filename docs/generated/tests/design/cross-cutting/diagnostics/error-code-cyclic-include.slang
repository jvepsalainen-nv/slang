//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A self-`#include` renders E15302 with the offending path interpolated.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `cyclic-include` (15302) to its rendered code by triggering
// a self-include via the file's own name. The `~path` interpolation
// inserts the verbatim include argument into the rendered message.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl
#include "error-code-cyclic-include.slang"
void main() {}

// CHECK: E15302
// CHECK: cyclic `#include` of file
// CHECK: error-code-cyclic-include.slang
