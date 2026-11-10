//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#diagnosticsink
//META: purpose=Boundary: a `#pragma warning(pop)` with an empty warning-state stack is itself reported as E15611.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the boundary of the warning-state stack the sink tracks per source:
// a `#pragma warning(pop)` with nothing pushed is itself diagnosable. The
// caret-anchored CHECK pins code 15611 and the unmatched-pop message at the
// pragma's column.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#pragma warning(pop)
//CHECK:        ^^^ E15611
//CHECK:        ^^^ detected #pragma warning(pop) with no corresponding #pragma warning(push)

void main() {}
