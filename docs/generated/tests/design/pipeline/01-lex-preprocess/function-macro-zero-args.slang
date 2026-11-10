//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#macro-expansion
//META: purpose=Boundary probe of function-style macros: a zero-parameter macro `FOO()` is valid and expands without taking arguments.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Function-style macro with **zero** parameters. The parameter
// environment that the doc describes still has to be allocated (it
// is empty), and the invocation `ZERO_ARG()` must replay the body.

//TEST:INTERPRET(filecheck=CHECK):

#define ZERO_ARG() 42

void main()
{
    // CHECK: zero=42
    printf("zero=%d\n", ZERO_ARG());
}
