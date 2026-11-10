//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A struct with no user-written `__init` still gets a synthesized member-wise constructor; a brace initializer fills fields in declaration order.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a constructor exists even when the user wrote none. The struct
// declares only fields; a positional brace initializer is used and the CHECK
// asserts a sum that distinguishes correct field ordering from any other
// assignment of the two literals.

//TEST:INTERPRET(filecheck=CHECK):

struct Pair
{
    int a;
    int b;
}

void main()
{
    Pair p = {3, 4};
    //CHECK: 7
    printf("%d\n", p.a + p.b);
}
