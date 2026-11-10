//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`const` makes a local variable immutable; assigning to it is diagnosed.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `const` is not merely decorative on a local: it makes the binding
// immutable. The variable is initialised once and then assigned again, and CHECK
// pins the not-modifiable error code, proving the checker treats the `const`
// declaration as a non-l-value target.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    const int x = 7;
    x = 42;
    //CHECK: error
    //CHECK: E30011
}
