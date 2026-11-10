//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=The facet walk keeps an extension whose target type equals the self type, so a direct member and a same-named extension member of that type accumulate into one overload set.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the extension-on-the-same-type special case of the facet
// walk. `twice(int)` is a direct member and `twice(float)` comes from
// an extension on S; both must survive into a single candidate set for
// the two calls to pick different bodies. CHECK asserts 6 + 102, which
// is only reachable if both facets contributed.

//TEST:INTERPRET(filecheck=CHECK):

struct S
{
    int twice(int v) { return v * 2; }
}

extension S
{
    int twice(float v) { return int(v) + 100; }
}

void main()
{
    S s;
    int r = s.twice(3) + s.twice(2.0f);
    // CHECK: r=108
    printf("r=%d\n", r);
}
