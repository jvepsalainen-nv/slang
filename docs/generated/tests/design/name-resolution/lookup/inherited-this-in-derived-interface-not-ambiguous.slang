//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=An inherited This candidate is suppressed for an interface, so a derived interface that also inherits This from its base can still name This without an ambiguity.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the special handling of an inherited This during the facet
// walk. IB inherits IA, so both interfaces contribute a self-type
// declaration; without the suppression the `This dup()` requirement in
// IB would see two candidates for This and fail to resolve. CHECK
// asserts 6 * 2, which requires IB to compile and the requirement to
// dispatch to the conformer.

//TEST:INTERPRET(filecheck=CHECK):

interface IA { int a(); }
interface IB : IA { This dup(); }

struct S : IB
{
    int k;
    int a() { return k; }
    This dup() { S s; s.k = k * 2; return s; }
}

int use<T : IB>(T t) { return t.dup().a(); }

void main()
{
    S s;
    s.k = 6;
    // CHECK: r=12
    printf("r=%d\n", use(s));
}
