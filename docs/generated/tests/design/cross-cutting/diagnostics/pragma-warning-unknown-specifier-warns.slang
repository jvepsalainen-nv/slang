//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#diagnosticsink
//META: purpose=Boundary: an unrecognised `#pragma warning` specifier is reported as E15613 with the offending specifier interpolated.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probe the edge of the pragma-warning suppression surface: when
// the specifier isn't one of `push`, `pop`, `disable`, `error`,
// `default`, `suppress`, etc., the preprocessor emits 15613 with
// the offending specifier interpolated via `~specifier`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
#pragma warning(maybe: 41024)
//CHECK:        ^^^^^ E15613
//CHECK:        ^^^^^ unknown #pragma warning specifier 'maybe'

void main() {}
