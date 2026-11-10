//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#unqualified-lookup
//META: purpose=In an effectively-static member function no this value is usable, so the breadcrumb is the This-type form and an unqualified name in its body resolves to a static member of the enclosing type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the static arm of the this-breadcrumb kind. A static
// method has no receiver, so the breadcrumb the scope walk records is
// the ThisType form, which names only the enclosing type; the unqualified read of `factor` must
// therefore bind to the static field. CHECK asserts 5 * 4, which is
// unreachable if `factor` failed to resolve without a receiver.

//TEST:INTERPRET(filecheck=CHECK):

struct U
{
    static const int factor = 4;
    static int scale(int x) { return x * factor; }
}

void main()
{
    // CHECK: r=20
    printf("r=%d\n", U::scale(5));
}
