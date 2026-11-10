//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#switch-statement
//META: purpose=A default label appearing outside a switch body is a compile error (E39999).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `default` label placed outside any switch body is rejected
// with E39999. The test puts `default:` directly inside a function body;
// CHECK asserts E39999 under the `default` token, proving the placement
// restriction applies to default labels as well as case labels.
//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = 0;
default:
/*CHECK:
^^^^^^^ E39999
^^^^^^^ 'default' is only allowed in a 'switch' body
*/
    x = 1;
}
