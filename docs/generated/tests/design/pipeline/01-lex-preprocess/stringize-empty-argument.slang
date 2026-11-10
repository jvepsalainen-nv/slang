//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=Boundary probe of stringize `#x`: an empty argument stringizes to an empty string literal `""`.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `STR()` invokes the macro with an empty argument token list. The
// resulting constructed string-literal token must be the empty
// string `""`. We emit to CPP and FileCheck for the literal in
// the emitted source (slangi printf does not support `%s`).

//TEST:SIMPLE(filecheck=CHECK):-target cpp -entry main -stage compute

#define STR(x) #x

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    printf("%s\n", STR());
    //CHECK: ""
}
