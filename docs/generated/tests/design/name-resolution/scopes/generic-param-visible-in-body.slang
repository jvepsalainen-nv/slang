//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#implicit-scopes
//META: purpose=A generic type parameter lives in the GenericDecl's scope; the inner decl's scope chain passes through it, so `T` resolves inside the function body.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Implicit scopes / Generic parameter list: `T` lives in the
// GenericDecl scope that wraps `identity`; from inside identity the
// parent chain reaches it.

//TEST:INTERPRET(filecheck=CHECK):

T identity<T>(T value) { return value; }

void main()
{
    int r = identity<int>(123);
    // CHECK: r=123
    printf("r=%d\n", r);
}
