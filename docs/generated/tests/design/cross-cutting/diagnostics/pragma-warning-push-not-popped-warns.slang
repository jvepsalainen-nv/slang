//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#diagnosticsink
//META: purpose=Boundary: a `#pragma warning(push)` left unpopped at end of file is reported as E15612.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the other boundary of the per-source warning-state stack: a
// `#pragma warning(push)` never popped before end of file is diagnosable.
// The caret-anchored CHECK pins code 15612 and the unmatched-push message.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#pragma warning(push)
//CHECK:        ^^^^ E15612
//CHECK:        ^^^^ detected #pragma warning(push) with no corresponding #pragma warning(pop)

void main() {}
