//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A FuncDecl owns its own scope; a local declared inside helper() is not visible from another function's scope.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// CallableDecl/FuncDecl is listed as scope-bearing. A name introduced
// in helper's body must not be reachable from main's body.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void helper()
{
    int local_in_helper = 5;
}

void main()
{
    helper();
    int y = local_in_helper;
//CHECK:    ^^^^^^^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^^^^^^^ undefined identifier 'local_in_helper'.
// CHECK: E30015
}
