//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=An unrecognized identifier after an explicit `slang` language name is reported as E15207 unknown language version, not as E15208 unknown language, because the language is already settled.
//META: intent=negative
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Which of the three `#lang` diagnostics fires depends on what the parser can
// still infer about the operand. With no language name given, a lone
// unrecognized identifier is read as an attempt to name a language and draws
// `UnknownLanguage`; once `slang` has been written the language is settled, so
// the same token can only have been a version and draws
// `UnknownLanguageVersion` instead. This pins the second arm, which is the one
// that distinguishes the current handler from its predecessor.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

#lang slang nosuchver
/*CHECK:
 ^^^^ error E15207
 ^^^^ unknown language version 'nosuchver'
*/

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    gOut[0] = 1;
}
