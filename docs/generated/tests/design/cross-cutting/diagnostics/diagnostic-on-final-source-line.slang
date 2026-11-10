//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=Boundary: a diagnostic on the file's final source line still resolves to a real source line and renders a caret.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Edge of source-location decoding at the upper file boundary:
// the offending token (an unterminated struct body) lives on the
// last line of the file. The renderer must still locate the
// source file and emit a caret-aligned diagnostic.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl
void main() {}
struct EndingStruct {
// CHECK: E20001
// CHECK: diagnostic-on-final-source-line.slang
