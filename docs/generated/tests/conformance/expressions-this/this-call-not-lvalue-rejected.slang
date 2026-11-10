//META: generated=true
//META: doc_ref=docs/language-reference/expressions-this.md#mutability
//META: purpose=A call expression is never an l-value; assigning to one is rejected with E30011.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a call expression is never an l-value and cannot appear on the left
// of an assignment. `makeVal() = 10` is invalid Slang; CHECK asserts E30011 fires,
// proving the compiler enforces this constraint at the assignment expression.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int makeVal() { return 5; }

void main()
{
    makeVal() = 10;
//CHECK:      ^ left of '=' is not an l-value.
}
