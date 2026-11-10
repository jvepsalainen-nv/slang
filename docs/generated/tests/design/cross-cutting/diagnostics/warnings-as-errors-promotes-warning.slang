//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#severity-levels
//META: purpose=The final `TreatWarningsAsErrors` step of `getEffectiveMessageSeverity` promotes warning 41024 to `error` when `-warnings-as-errors 41024` selects it by id.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the last step of the effective-severity computation: a warning that
// survives the earlier steps is promoted to Error when warnings-as-errors
// selects it. The comma-operator warning is compiled with
// `-warnings-as-errors 41024`; the annotation asserts the reported severity
// word at that column is `error` rather than `warning`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK): -warnings-as-errors 41024
int main()
{
    int x = (1, 2);
//CHECK:      ^ error
//CHECK:      ^ comma operator used in expression
    return x;
}
