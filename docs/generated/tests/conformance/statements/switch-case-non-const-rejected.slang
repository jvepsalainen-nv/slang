//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#switch-statement
//META: purpose=A case expression that does not evaluate to a compile-time constant integer is rejected (E39999).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `case` label whose expression is a runtime variable is
// rejected with E39999. The test uses `case y:` where `y` is an `int` local;
// CHECK asserts E39999 at that token, proving the compiler requires a
// compile-time constant integer in case expressions.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int v = 1;
    int x = 0;
    int y = 2;
    switch (v)
    {
    case y:
         /*CHECK:
         ^ E39999
         */
        x = 1;
        break;
    }
}
