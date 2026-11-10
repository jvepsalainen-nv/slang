//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An ExplicitCtorInvokeExpr `T(...)` is a constructor invocation; it returns a value of type T built from the arguments.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ExplicitCtorInvokeExpr inherits InvokeExpr and represents an
// explicit `T(...)` constructor call. We define a user constructor
// on a struct and invoke it; the resulting fields must reflect the
// constructor's assignments.

//TEST:INTERPRET(filecheck=CHECK):

struct Box
{
    int w;
    int h;

    __init(int wi, int hi) { w = wi; h = hi; }
}

void main()
{
    Box b = Box(3, 5);
    // CHECK: w=3 h=5
    printf("w=%d h=%d\n", b.w, b.h);
}
