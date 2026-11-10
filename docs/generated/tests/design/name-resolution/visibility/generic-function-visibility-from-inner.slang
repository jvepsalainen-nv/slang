//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#generic-parameters-accessors-and-synthesized-members
//META: purpose=A `GenericDecl` takes its visibility from the inner decl; a public generic function is reachable through the public-on-inner classification.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `getDeclVisibility` for a `GenericDecl` returns the visibility of
// its `inner` decl. Marking the inner function `public` makes the
// generic function callable.

//TEST:INTERPRET(filecheck=CHECK):

public int identity<T : IInteger>(T x) where T == int { return int(x); }

void main()
{
    // CHECK: id=11
    printf("id=%d\n", identity(11));
}
