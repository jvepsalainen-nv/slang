//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=A companion note renders with the user-facing severity name `note`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// function-redefinition (E30201) carries a companion diagnostic at
// Severity::Note pointing at the original definition. Verify that
// the rendered severity word on the note line is "note", and that
// the primary diagnostic line carries "error" per getSeverityName().

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int foo(){ return 1; }
/*CHECK:
    ^^^ see previous definition of 'foo'
*/

int foo(){ return 2; }
/*CHECK:
    ^^^ function 'foo' already has a body
    ^^^ redeclared here
*/
