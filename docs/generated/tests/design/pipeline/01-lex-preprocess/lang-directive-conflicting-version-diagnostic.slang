//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=Only the first Slang language-version selection in a source segment is kept; a later `#lang` naming a different version is diagnosed as a conflict (E00126) and the first selection stays in force.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `_tryApplySourceLanguageDirective` keeps the first selection and diagnoses a
// later directive naming a different Slang version
// (`ConflictingSlangLanguageVersionDirectives`, E00126). The second `#lang`
// here selects 2026 after 2025, so it must be reported, with a note pointing
// at the first directive.

//TEST:SIMPLE(filecheck=CHECK,exit-code=-1):-target hlsl -entry main -stage compute

#lang 2025
#lang 2026

[shader("compute")]
[numthreads(1, 1, 1)]
void main() {}

// CHECK: E00126
// CHECK: first Slang language-version directive
