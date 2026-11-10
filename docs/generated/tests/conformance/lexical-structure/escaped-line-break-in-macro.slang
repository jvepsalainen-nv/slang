//META: generated=true
//META: doc_ref=docs/language-reference/lexical-structure.md#escaped-line-breaks
//META: purpose=An escaped line break (`\` immediately before a newline) is eliminated during phase 2 of compilation, joining the two physical lines into one logical line.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The classic exercise: a preprocessor macro whose body spans
// multiple physical lines via `\<newline>`. The expansion must
// behave as if the body were one line.

//TEST:INTERPRET(filecheck=CHECK):

#define SUM_THREE(a, b, c) \
    ((a) + \
     (b) + \
     (c))

void main()
{
    int v = SUM_THREE(1, 2, 4);
    //CHECK: v=7
    printf("v=%d\n", v);
}
