//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=`__LINE__` is a constructed token synthesized fresh at each use; it expands to the line number of the use site.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `__LINE__` expands to an integer token at the use
// site. The reference is on line 18 of this file; if the doc claim
// that `__LINE__` is a constructed token attributed to the
// invocation site holds, the printed value must be 22.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // CHECK: line=18
    printf("line=%d\n", __LINE__);
}
