//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#diagnosticsink
//META: purpose=With no severity override registered in the sink, the comma-operator warning E41024 reaches the user unchanged.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Positive control for the suppression tests: with no override registered the
// same comma-operator expression that `#pragma warning(disable: 41024)`
// silences does reach the user. CHECK pins the code and message at the comma's
// column, so the suppression tests are known to be changing behaviour.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int main()
{
    int x = (1, 2);
//CHECK:      ^ E41024
//CHECK:      ^ comma operator used in expression
    return x;
}
