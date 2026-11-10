//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Verifies an unrecognized -line-directive-mode value is rejected with E00062 listing the accepted modes.
//META: intent=characterization
//META: covers=source/slang/slang-options.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization of the value-category parse for OptionKind::LineDirectiveMode.
// An unknown mode string falls through to E00062. The diagnostic is on the
// synthetic command line (line 0) and is pinned by error code. Observed message
// recorded verbatim: "unknown value for option '-line-directive-mode'. Valid
// values are 'none, source-map, default, standard, glsl'".

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -line-directive-mode bogus -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main() {}

//CHECK: E00062
