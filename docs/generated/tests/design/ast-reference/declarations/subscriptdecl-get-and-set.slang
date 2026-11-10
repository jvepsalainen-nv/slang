//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A SubscriptDecl with both get and set accessors makes an indexed expression assignable as well as readable.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a subscript declaring both accessors supports index syntax on
// either side of an assignment. Two elements are written through the setter
// and read back through the getter; the CHECK asserts their sum, which
// requires both accessors to be wired to the same backing storage.

//TEST:INTERPRET(filecheck=CHECK):

struct Cells
{
    int a[3];
    __subscript(int i) -> int
    {
        get { return a[i]; }
        set { a[i] = newValue; }
    }
}

void main()
{
    Cells c;
    c[0] = 5;
    c[1] = 6;
    //CHECK: 11
    printf("%d\n", c[0] + c[1]);
}
