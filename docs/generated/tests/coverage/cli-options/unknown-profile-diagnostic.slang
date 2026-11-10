//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/targets.md#profiles
//META: purpose=Verifies an unrecognized -profile operand is rejected with E00014 naming the unknown profile.
//META: intent=characterization
//META: covers=source/slang/slang-options.cpp
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Characterization of -profile operand handling (Profile::lookUp returning
// SLANG_PROFILE_UNKNOWN) in slang-options.cpp. An unknown profile name diagnoses
// E00014. The diagnostic is anchored to the synthetic command line, so it is
// pinned by error code. Observed message recorded verbatim: "unknown profile
// 'zzz'".

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -profile zzz -entry main -stage compute

[shader("compute")]
[numthreads(1, 1, 1)]
void main() {}

//CHECK: E00014
