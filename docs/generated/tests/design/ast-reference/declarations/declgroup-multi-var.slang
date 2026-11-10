//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A DeclGroup wraps multiple declarations parsed as one group (`int a, b;`); each name is independently visible.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a comma-separated declaration introduces two independent
// names rather than one. Each name is assigned a different value and the
// CHECK asserts their sum, which is only correct if both bindings exist
// separately.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a, b;
    a = 3;
    b = 5;
    //CHECK: 8
    printf("%d\n", a + b);
}
