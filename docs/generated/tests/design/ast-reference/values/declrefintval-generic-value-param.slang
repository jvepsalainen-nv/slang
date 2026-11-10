//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#intval-family
//META: purpose=A generic value parameter is an unsubstituted compile-time integer that only collapses to a constant after generic application, so the array it bounds carries the substituted size.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the symbolic end of the IntVal family: `let N : int` names
// an integer that is not known while the generic is being checked, and
// becomes concrete only at `Buf<3>`. The test writes three slots of
// `data` and prints them; CHECK asserts all three round-trip, which
// requires the bound to have become the constant 3 at instantiation.

//TEST:INTERPRET(filecheck=CHECK):

struct Buf<let N : int>
{
    int data[N];
}

void main()
{
    Buf<3> b;
    b.data[0] = 10;
    b.data[1] = 20;
    b.data[2] = 30;
    // CHECK: b=10,20,30
    printf("b=%d,%d,%d\n", b.data[0], b.data[1], b.data[2]);
}
