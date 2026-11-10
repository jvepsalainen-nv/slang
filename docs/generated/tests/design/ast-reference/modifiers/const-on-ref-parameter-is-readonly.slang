//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=On a `__ref` parameter, `const` is the legacy alias of `__ref_readonly`: assigning through it is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `ConstModifier` row: `const` written on a `__ref` parameter
// makes the parameter read-only in the callee, so the write is rejected. CHECK
// pins the not-an-l-value error code, which shows the `const` took effect
// rather than being ignored.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void f(const __ref int x)
{
    x = 1;
    //CHECK: error
    //CHECK: E30011
}

void main()
{
    int a = 0;
    f(a);
}
