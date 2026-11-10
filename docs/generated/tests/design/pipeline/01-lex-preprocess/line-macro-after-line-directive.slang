//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#source-location-preservation
//META: purpose=Boundary probe of `__LINE__`: after a `#line 1000` directive, `__LINE__` reports a large value (boundary far from physical line 1).
//META: intent=boundary
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A `#line 1000` directive shifts the logical line counter. The
// subsequent `__LINE__` constructed token must reflect the shifted
// value, so we observe the large-line boundary without having to
// pad the test file out to 1000 physical lines.

//TEST:INTERPRET(filecheck=CHECK):

#line 1000
void main()
{
    // CHECK: line=1003
    printf("line=%d\n", __LINE__);
}
