//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A BlockStmt introduces a fresh scope; a local declared inside is not visible outside that block.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The scope-bearing-AST-nodes table lists BlockStmt as a fresh scope.
// A local declared inside it must not be visible outside.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    {
        int local_in_block = 5;
    }
    int y = local_in_block;
//CHECK:    ^^^^^^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^^^^^^ undefined identifier 'local_in_block'.
// CHECK: E30015
}
