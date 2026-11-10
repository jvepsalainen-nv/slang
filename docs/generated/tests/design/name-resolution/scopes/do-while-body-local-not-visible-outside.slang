//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A do-while loop's block body owns its own scope (the parser does not push a fresh ScopeDecl on the DoWhileStmt itself); a local declared in the body is not visible after the loop.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the do-while sibling of the while-body boundary: the
// scope-bearing-nodes table says ParseDoWhileStatement never assigns a
// fresh ScopeDecl, so body locals live in the body BlockStmt's scope
// only. A read after the loop must fail as an undefined identifier.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    do
    {
        int inside_do = 9;
    }
    while (false);
    int y = inside_do;
//CHECK:    ^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^ undefined identifier 'inside_do'.
// CHECK: E30015
}
