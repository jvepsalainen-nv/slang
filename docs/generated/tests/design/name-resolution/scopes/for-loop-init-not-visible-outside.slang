//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=ForStmt owns its own scope; the init-statement's variable is not visible after the loop.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ForStmt is listed as scope-bearing (in contrast to UnscopedForStmt
// in HLSL mode). The loop variable lives in the ForStmt's scope only.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    for (int i = 0; i < 3; ++i)
    {
    }
    int z = i;
//CHECK:    ^ undefined identifier
//CHECK:    ^ undefined identifier 'i'.
// CHECK: E30015
}
