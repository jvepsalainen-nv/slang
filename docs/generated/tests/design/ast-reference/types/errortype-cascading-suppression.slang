//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#errortype-and-bottomtype
//META: purpose=ErrorType is the type of an expression that failed to check and keeps downstream checking from cascading, so a single root cause yields a single diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the non-cascade property: one undefined identifier poisons
// the initialiser, and the three later expressions that consume the
// poisoned local must not each report a fresh error. CHECK pins the
// single undefined-identifier diagnostic; any cascading mismatch on the
// following lines would leave unmatched diagnostics.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    int x = bogusName;
//CHECK:    ^^^^^^^^^ undefined identifier 'bogusName'.
    int y = x + 1;
    int z = x * 2;
    int w = y + z;
    printf("%d\n", w);
}
