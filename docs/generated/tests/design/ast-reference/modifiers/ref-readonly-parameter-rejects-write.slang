//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#reference-parameter-keywords
//META: purpose=`__ref_readonly` is a by-reference parameter passing mode that is read-only in the callee: writing through it is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `RefReadOnlyModifier` row. The keyword is core-module-only, so
// the test enables `-experimental-feature` to let user code spell it. The
// callee assigns to the parameter and CHECK pins the not-an-l-value error
// code that the read-only access mode produces.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-experimental-feature

void f(__ref_readonly int x)
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
