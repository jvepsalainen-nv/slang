//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A CountOfExpr `countof(T)` yields the number of elements in a static type pack.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CountOfExpr is documented as `countof(T)` (element count of a
// static type pack / tuple). We use a variadic int generic and call
// countof on the parameter pack inside the generic.

//TEST:INTERPRET(filecheck=CHECK):

struct Dims<let each D : int>
{
    static const int n = countof(D);
}

void main()
{
    static const int n = Dims<10, 20, 30, 40>.n;
    // CHECK: n=4
    printf("n=%d\n", n);
}
