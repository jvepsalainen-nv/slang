//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=Struct fields live in the AggTypeDecl's scope only; they are not visible from a free function at file scope.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// AggTypeDecl owns its own scope; fields are not in the enclosing
// file scope. A free function attempting to use `field` unqualified
// reports undefined-identifier.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S {
    int field;
    int read() { return field; }
}

void main()
{
    S s = {7};
    int x = field;
//CHECK:    ^^^^^ undefined identifier
//CHECK:    ^^^^^ undefined identifier 'field'.
// CHECK: E30015
}
