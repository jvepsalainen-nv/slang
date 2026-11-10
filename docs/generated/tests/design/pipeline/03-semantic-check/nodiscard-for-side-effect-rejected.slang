//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=The discarded-result check also covers a `for` loop side-effect expression, so a `[NoDiscard]` call written there is reported (E30059).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `for` side-effect position the refreshed doc names alongside
// the bare expression statement: the third clause of the loop is evaluated
// only for effect, so its value is discarded. CHECK pins E30059.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

[NoDiscard]
int f()
{
    return 1;
}

void main()
{
    for (int i = 0; i < 2; f())
//CHECK: E30059
    {
        i++;
    }
}
