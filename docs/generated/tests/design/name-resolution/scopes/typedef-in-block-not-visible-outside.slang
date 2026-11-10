//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A typedef declared inside a block lives in the BlockStmt's scope only; it cannot be referenced from a later statement at the enclosing scope.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// BlockStmt is a scope-bearing AST node. A typedef inside it shares
// the block's lifetime; using the alias outside the block is
// undefined.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    {
        typedef int LocalAlias;
        LocalAlias a = 1;
    }
    LocalAlias b = 2;
/*CHECK:
    ^^^^^^^^^^ undefined identifier
    ^^^^^^^^^^ undefined identifier 'LocalAlias'.
*/
// CHECK: E30015
}
