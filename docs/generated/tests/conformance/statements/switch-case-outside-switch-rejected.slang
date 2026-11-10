//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#switch-statement
//META: purpose=A case label appearing outside a switch body is a compile error (E39999).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `case` label placed outside any switch body is rejected
// with E39999. The test puts `case 1:` directly inside a function body;
// CHECK asserts E39999 under the `case` token, proving the placement
// restriction is enforced.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = 0;
case 1:
/*CHECK:
^^^^ E39999
^^^^ 'case' is only allowed in a 'switch' body
*/
    x = 1;
}
