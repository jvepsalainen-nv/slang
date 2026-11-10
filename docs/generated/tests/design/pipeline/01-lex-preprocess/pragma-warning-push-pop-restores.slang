//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/01-lex-preprocess.md#pragma-warning-state-across-files
//META: purpose=`#pragma warning(push)` saves warning state and `#pragma warning(pop)` restores it, re-enabling a warning disabled inside the push/pop region.
//META: intent=functional
//META: pipeline_stage=preprocess
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the push/pop arms of the warning-state tracker: W30081
// is disabled inside a push/pop region, so the conversion there must
// not warn (the CHECK-NOT region runs up to the first match), while
// the identical conversion after the pop must warn again because pop
// restored the enabled state saved by push.

//TEST:SIMPLE(filecheck=CHECK):

int64_t getValue();

#pragma warning (push)
#pragma warning (disable : 30081)

void insidePushRegion()
{
    int i;
    // CHECK-NOT: warning[E30081]
    i = getValue();
}

#pragma warning (pop)

void afterPop()
{
    int i;
    // CHECK: warning[E30081]
    i = getValue();
}
