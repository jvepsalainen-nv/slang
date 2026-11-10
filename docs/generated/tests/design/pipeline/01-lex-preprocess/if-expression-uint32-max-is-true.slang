//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=Boundary probe of `#if`: `0xFFFFFFFF` (uint32 MAX) evaluates as non-zero and selects the active branch.
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// 0xFFFFFFFF is the documented uint32 MAX. In a preprocessor `#if`
// it must be treated as a non-zero value so the active branch wins.

//TEST:INTERPRET(filecheck=CHECK):

#if 0xFFFFFFFF
static const int picked = 1;
#else
static const int picked = 0;
#endif

void main()
{
    // CHECK: picked=1
    printf("picked=%d\n", picked);
}
