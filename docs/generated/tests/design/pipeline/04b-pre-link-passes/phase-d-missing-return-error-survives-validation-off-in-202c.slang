//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04b-pre-link-passes.md#per-translation-unit-predicates
//META: purpose=Phase D's D5 missing-return check also runs from the else arm when non-essential validation is off but languageVersion >= 202C, so the missing-return error is unconditional from 202C.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the language-version-gated arm of Phase D. With
// `-disable-non-essential-validations` the D3-D9 validator block is
// skipped, yet D5 (checkForMissingReturns) still runs when the language
// version is 202C or later, and from 202C the missing return is an error
// (E40025). The paired run at language version 2025 keeps the documented
// behaviour of the toggle: no diagnostic at all and HLSL still emitted.

//TEST:SIMPLE(filecheck=NEW,exit-code=-1):-target hlsl -stage compute -entry main -disable-non-essential-validations -lang slang -std 202c
//TEST:SIMPLE(filecheck=OLD):-target hlsl -stage compute -entry main -disable-non-essential-validations -lang slang -std 2025

uniform int a;
uniform RWStructuredBuffer<int> buf;

int helper(int x) { if (x > 0) return 1; }

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = helper(a);
}

// NEW: E40025

// OLD-NOT: 40025
// OLD-NOT: 41010
// OLD: RWStructuredBuffer<int
