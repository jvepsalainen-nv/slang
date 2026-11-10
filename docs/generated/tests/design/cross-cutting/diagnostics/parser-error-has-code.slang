//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Parser diagnostics take ids from the conventional 2xxxx subsystem range.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that parser diagnostics draw their ids from the conventional
// 2xxxx subsystem range. A parameter list is opened and never closed; the
// caret-anchored CHECK pins the rendered code E20001 at the offending column,
// so a renumbering out of the parser range would fail the test.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int main(
{
/*CHECK:
^ E20001
^ expected identifier
*/
    return 0;
}
