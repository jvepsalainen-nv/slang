//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#substitution-and-the-substitution-cache
//META: purpose=Substitution rebuilds a value from its substituted operands, so a generic argument that is itself an expression over the outer generic's parameter reaches the inner generic already specialized.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that substitution reaches through a nested generic
// application: Outer<N> supplies `N + 1` as Inner's value argument, so
// Inner's array bound is a value rebuilt from the substituted outer
// parameter. The same expression also bounds Outer's own `mirror`
// array, and the whole-array assignment between them is checked, so
// both occurrences must substitute to the same bound. CHECK asserts all
// three copied slots, i.e. the bound resolved to 3 for Outer<2>.

//TEST:INTERPRET(filecheck=CHECK):

struct Inner<let M : int>
{
    int cells[M];
}

struct Outer<let N : int>
{
    Inner<N + 1> inner;
    int mirror[N + 1];
}

void main()
{
    Outer<2> o;
    o.inner.cells[0] = 5;
    o.inner.cells[1] = 6;
    o.inner.cells[2] = 7;
    o.mirror = o.inner.cells;
    // CHECK: m=5,6,7
    printf("m=%d,%d,%d\n", o.mirror[0], o.mirror[1], o.mirror[2]);
}
