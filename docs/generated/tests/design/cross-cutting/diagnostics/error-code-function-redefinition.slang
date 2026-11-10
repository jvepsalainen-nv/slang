//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Codes are unique per entry: function-redefinition renders its own code E30201, distinct from its neighbours.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a diagnostic renders the id it was declared with (ids are
// normally unique even though the namespace admits intentional sharing).
// Pin the rendered code for function-redefinition to E30201 by FileChecking
// it on the redefinition line.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int foo(){ return 1; }
/*CHECK:
    ^^^ see previous definition of 'foo'
*/

int foo(){ return 2; }
/*CHECK:
    ^^^ E30201
    ^^^ redeclared here
*/
