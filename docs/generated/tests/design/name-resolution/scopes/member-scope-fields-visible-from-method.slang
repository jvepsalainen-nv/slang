//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=AggTypeDecl/StructDecl introduces a scope; a method body declared inside the struct can refer to the struct's fields by unqualified name.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// AggTypeDecl is listed as scope-bearing. The method's scope chain
// passes through the StructDecl, so unqualified `x` and `y` resolve
// to fields.

//TEST:INTERPRET(filecheck=CHECK):

struct Pair {
    int x;
    int y;
    int sum() { return x + y; }
}

void main()
{
    Pair p = {3, 5};
    int s = p.sum();
    // CHECK: s=8
    printf("s=%d\n", s);
}
