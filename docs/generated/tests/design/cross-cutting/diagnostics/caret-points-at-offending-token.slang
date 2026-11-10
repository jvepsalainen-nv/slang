//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#source-locations-and-message-rendering
//META: purpose=The sink decodes the `SourceLoc` through `SourceManager` and renders a caret at the offending token's column.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the caret is placed at the column of the offending token. The
// undeclared name `b` starts at column 13; the annotation puts a single caret
// there, and the runner compares annotated column against reported column, so
// any drift in the decoded column fails the test.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
void main()
{
    int a = b;
//CHECK:    ^ undefined identifier
//CHECK:    ^ undefined identifier 'b'.
}
