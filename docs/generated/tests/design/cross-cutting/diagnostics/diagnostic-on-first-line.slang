//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=Boundary: a diagnostic on line 1 (the lower edge of the line-number axis) still renders `:1:` in the decoded triple.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Edge of the source-location decoding for the line-number axis:
// use `#line 1` to remap the next physical line back to logical
// line 1, then trigger an undefined-identifier on that line. The
// renderer must emit the remapped `:1:` in the rendered location,
// confirming the line-number boundary is correctly carried through
// SourceManager.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

#line 1
int g = nonexistentGlobal;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID) {}

// CHECK: :1:
// CHECK: undefined identifier 'nonexistentGlobal'
