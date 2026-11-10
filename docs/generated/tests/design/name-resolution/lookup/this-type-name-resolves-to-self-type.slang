//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#member-lookup
//META: purpose=The name This inside a non-interface aggregate type resolves to the enclosing type's own decl-ref rather than being looked up as an ordinary member.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the first case of the member-lookup decl handler: This in
// something that is not an interface short-circuits to the decl-ref
// being searched. The static factory declares its local and its return
// type as `This`, which must denote Box; CHECK asserts the field read
// back through a `Box`-typed variable, which only type-checks if This
// resolved to Box itself.

//TEST:INTERPRET(filecheck=CHECK):

struct Box
{
    int v;
    static This make(int n) { This b; b.v = n; return b; }
}

void main()
{
    Box b = Box::make(9);
    // CHECK: r=9
    printf("r=%d\n", b.v);
}
