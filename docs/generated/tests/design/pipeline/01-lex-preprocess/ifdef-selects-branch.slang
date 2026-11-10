//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#preprocessor-directives
//META: purpose=The preprocessor supports the standard C/HLSL conditional set, including `#ifdef` selecting the active branch when the named macro is defined.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `#ifdef NAME` activates its branch when `NAME` has
// been defined. With `FEATURE` defined, the value 1 is picked; the
// `#else` branch would yield 0.

//TEST:INTERPRET(filecheck=CHECK):

#define FEATURE

#ifdef FEATURE
static const int picked = 1;
#else
static const int picked = 0;
#endif

void main()
{
    // CHECK: picked=1
    printf("picked=%d\n", picked);
}
