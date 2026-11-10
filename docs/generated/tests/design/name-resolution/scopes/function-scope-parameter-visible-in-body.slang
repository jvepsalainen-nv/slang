//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A CallableDecl's scope contains its parameter decls; the parameter is reachable from the function body.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The scope-bearing table notes that CallableDecl's scope "contains
// the parameter decls". Verify by reading the parameter from inside
// the body.

//TEST:INTERPRET(filecheck=CHECK):

int square(int n)
{
    return n * n;
}

void main()
{
    int r = square(7);
    // CHECK: r=49
    printf("r=%d\n", r);
}
