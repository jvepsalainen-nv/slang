//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=A diagnostic declared at `Severity::Error` renders with the user-facing severity name `error`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the severity name rendered for an entry declared with the `err`
// helper. Undefined-identifier (E30015) is such an entry; the caret-anchored
// CHECK asserts the severity word reported at the offending column is `error`,
// which is the user-facing name of `Severity::Error`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
void main()
{
    int a = b;
//CHECK:    ^ error
//CHECK:    ^ undefined identifier
}
