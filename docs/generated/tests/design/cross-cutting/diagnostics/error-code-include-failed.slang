//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=A missing `#include` file renders E15300 with the requested path interpolated.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `include-failed` (15300) to its rendered code by including a
// path that does not exist on disk. The diag is preprocessor-stage
// and has its own id distinct from cyclic-include (15302).

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl
#include "this-file-does-not-exist-anywhere-12345.slang"
void main() {}

// CHECK: E15300
// CHECK: include file not found
