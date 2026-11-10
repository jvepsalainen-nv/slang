//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=The rendered caret run spans the full offending token rather than only its first column.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the rendered caret run covers the whole offending token rather
// than only its first column. The undeclared name is 18 characters long and
// the annotation supplies exactly 18 carets; the runner compares the annotated
// column range against the reported one, so a one-column span would fail.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
void main()
{
    int a = longUndeclaredName;
//CHECK:    ^^^^^^^^^^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^^^^^^^^^^ undefined identifier 'longUndeclaredName'.
}
