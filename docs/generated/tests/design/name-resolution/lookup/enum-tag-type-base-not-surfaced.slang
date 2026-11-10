//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#edge-cases-and-failure-modes
//META: purpose=The synthetic tag-type inheritance on an enum is filtered out of the facet walk, so the underlying integer type's members are not reachable as enum members (E30027).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the enum-to-tag-type inheritance is excluded from
// lookup. Color declares int as its tag type, so a facet for int would
// otherwise surface int's members through an enum value. Reaching for
// one of those members must fail exactly like any absent member; CHECK
// annotates the member-not-found diagnostic naming 'Color' as the host
// type, which shows the int facet never contributed.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

enum Color : int { Red, Green, Blue }

void main()
{
    Color c = Color::Red;
    int v = c.asInt();
//CHECK:      ^^^^^ member not found
//CHECK:      ^^^^^ 'asInt' is not a member of 'Color'.
// CHECK: E30027
}
