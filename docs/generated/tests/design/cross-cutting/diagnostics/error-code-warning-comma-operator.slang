//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/diagnostics.md#error-code-namespace
//META: purpose=Warnings draw ids from the same integer namespace as errors: comma-operator-used-in-expression renders E41024.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that warnings draw ids from the same integer namespace as errors.
// A comma operator in a value context triggers comma-operator-used-in-expression;
// the caret-anchored CHECK pins the rendered code E41024 at the comma's column.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):
int main()
{
    int x = (1, 2);
//CHECK:      ^ E41024
//CHECK:      ^ comma operator used in expression
    return x;
}
