//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=Member lookup on an interface-typed (existential) value targets the interface's implicit ThisType decl-ref, so the requirement is callable on the erased value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the existential arm of the member-lookup type dispatch. The
// local `c` is declared with the interface type, so its static type is
// an existential rather than the concrete struct; lookup must retarget
// at the interface's implicit self-type decl-ref for `c.val()` to
// resolve. CHECK asserts 5, produced by the concrete conformer stored
// in the existential.

//TEST:INTERPRET(filecheck=CHECK):

interface ICounter { int val(); }

struct S : ICounter { int val() { return 5; } }

void main()
{
    ICounter c = S();
    // CHECK: r=5
    printf("r=%d\n", c.val());
}
