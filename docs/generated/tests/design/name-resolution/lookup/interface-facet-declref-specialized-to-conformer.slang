//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=A member found through an interface facet comes back already specialized to the concrete conforming type, so a requirement returning This yields the conformer type at the call site.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the interface facet's parent decl-ref carries the
// conformance witness, so members found through it are specialized.
// `clone()` is declared on ICloneable returning `This`; calling it on
// an S receiver must yield S, not the abstract self type. CHECK
// asserts the result's `v` field is readable and equals 41 + 1, which
// requires the returned type to be the concrete struct.

//TEST:INTERPRET(filecheck=CHECK):

interface ICloneable { This clone(); }

struct S : ICloneable
{
    int v;
    This clone() { S s; s.v = v + 1; return s; }
}

void main()
{
    S s;
    s.v = 41;
    S t = s.clone();
    // CHECK: r=42
    printf("r=%d\n", t.v);
}
