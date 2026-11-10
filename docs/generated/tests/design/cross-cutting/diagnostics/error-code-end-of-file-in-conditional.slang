//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=An unterminated `#if` renders E15000 plus a note pointing back at the opening directive.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Pin `end-of-file-in-preprocessor-conditional` (15000) to its
// rendered code. The diag chain also emits a note pointing back
// at the originating `#if` — verify both via FileCheck.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl

#if 1
void main() {}

// CHECK: E15000
// CHECK: end of file encountered during preprocessor conditional
// CHECK: see 'if' directive
