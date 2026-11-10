//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=The preprocessor supports the standard C/HLSL `#define`/`#undef` pair, and `#undef` removes a macro so that a subsequent `#ifdef` is false.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Defines a macro, then `#undef`s it. A `#ifdef` after `#undef` must
// be false, so the `#else` branch picks the value 0. If `#undef`
// were a no-op, the `#ifdef` would still be true and the printed
// value would be 1.

//TEST:INTERPRET(filecheck=CHECK):

#define TEMP
#undef TEMP

#ifdef TEMP
static const int picked = 1;
#else
static const int picked = 0;
#endif

void main()
{
    // CHECK: picked=0
    printf("picked=%d\n", picked);
}
