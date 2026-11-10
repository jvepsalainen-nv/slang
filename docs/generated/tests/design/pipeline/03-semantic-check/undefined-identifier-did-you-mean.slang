//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#failure-modes
//META: purpose=An undefined identifier that is one edit away from an in-scope name carries a conservative did-you-mean suggestion on the diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the similar-name suggestion attached to the undefined-identifier
// diagnostic. The misspelling drops a single trailing character from a long
// in-scope local, which is inside the length-scaled edit budget, so the
// suggestion must appear. CHECK pins E30015 and the suggestion note naming the
// intended identifier.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    int myLongVariableName = 3;
    int y = myLongVariableNam;
//CHECK: E30015
//CHECK: did you mean 'myLongVariableName'?
}
