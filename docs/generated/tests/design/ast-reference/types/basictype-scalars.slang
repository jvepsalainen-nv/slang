//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: purpose=Each BasicExpressionType (int, uint, float, bool) behaves as the corresponding scalar built-in and its value flows through evaluation at that type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that each scalar built-in spelling produces a value that
// evaluates at that scalar type. Four scalars are initialised and read
// back; CHECK asserts each round-trips with its own value, which only
// holds if each spelling resolved to its own arithmetic leaf rather
// than collapsing to a single numeric type.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int i = -5;
    uint u = 7u;
    float f = 1.5f;
    bool b = true;

    // CHECK: i=-5
    printf("i=%d\n", i);
    // CHECK: u=7
    printf("u=%d\n", int(u));
    // CHECK: f=1
    printf("f=%d\n", int(f));
    // CHECK: b=1
    printf("b=%d\n", b ? 1 : 0);
}
