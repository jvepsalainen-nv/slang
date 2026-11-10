//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=The #lang version operand is resolved by name through one table in which each version carries several accepted spellings, so `202b` selects the same version as `2026`.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `HandleLanguageDirective` hands the operand's *text* to
// `TypeTextUtil::findLanguageVersion` whether it arrived as an identifier or
// as an integer literal, so the letter-suffixed spellings are not a separate
// code path -- they are extra names on the same table row. This pins `202b`,
// the spelling that shares a row with `2026`; if the alias were dropped the
// directive would report E15207 rather than compiling.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

#lang 202b

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    gOut[0] = 1;
}

// CHECK: void main
