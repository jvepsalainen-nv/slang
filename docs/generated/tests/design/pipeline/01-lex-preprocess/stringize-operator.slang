//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=The stringize operator `#x` synthesizes a fresh string-literal token whose content is the spelling of the argument.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `#x` produces a string literal whose content is the
// text of the argument. We emit to CPP and FileCheck for the
// quoted spelling in the emitted source (slangi printf does not
// support `%s`).

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

#define STR(x) #x

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", STR(hello));
    //CHECK: "hello"
}
