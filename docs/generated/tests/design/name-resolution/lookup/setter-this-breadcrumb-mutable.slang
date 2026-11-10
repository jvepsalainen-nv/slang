//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#unqualified-lookup
//META: purpose=A property setter body has a writable this (decided by the checker when the ThisExpr breadcrumb is expanded), so an unqualified assignment to a backing field inside the set accessor updates the receiver.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the implicit `this` created from a ThisExpr breadcrumb
// is writable inside a setter (the effective this-parameter
// information of the accessor, not lookup, supplies that). The set
// accessor writes the backing field `_v` by unqualified name; CHECK
// asserts the receiver holds 12 * 2 afterwards, which requires the
// breadcrumb to have carried a mutable `this` out of the accessor.

//TEST:INTERPRET(filecheck=CHECK):

struct Holder
{
    int _v;
    property int v
    {
        get { return _v; }
        set { _v = newValue * 2; }
    }
}

void main()
{
    Holder h;
    h.v = 12;
    // CHECK: r=24
    printf("r=%d\n", h._v);
}
