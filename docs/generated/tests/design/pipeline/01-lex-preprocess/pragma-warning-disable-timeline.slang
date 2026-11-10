//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#pragma-warning-state-across-files
//META: purpose=`#pragma warning(disable)` state is tracked on a source-location timeline: the same construct warns before the directive and is silent after it.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that warning state is resolved by source position on the
// tracker's timeline: an int64_t-to-int implicit conversion before
// the disable directive emits W30081, while the identical construct
// after the directive stays silent. The CHECK matches the first
// warning; the trailing CHECK-NOT proves no second one follows.

//TEST:SIMPLE(filecheck=CHECK):

int64_t getValue();

void beforeDirective()
{
    int i;
    // CHECK: warning[E30081]
    i = getValue();
}

#pragma warning (disable : 30081)

void afterDirective()
{
    int i;
    // CHECK-NOT: warning[E30081]
    i = getValue();
}
