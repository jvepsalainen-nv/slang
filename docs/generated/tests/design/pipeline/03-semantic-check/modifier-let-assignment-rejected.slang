//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#modifier-validation
//META: purpose=Modifier validation enforces the immutability of a `let` binding, so assigning to one is rejected as a non-l-value (E30011).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the immutability half of `let` from the assignment side, which is
// the complementary observation to the mutating-method rule. The binding has a
// value but no assignable storage. CHECK pins E30011 at the assignment.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    let a = 1;
    a = 2;
//CHECK: E30011
}
