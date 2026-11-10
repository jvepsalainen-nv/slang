//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A `let`-bound local declared inside a block lives in the BlockStmt's scope only; it cannot be referenced from a later statement at the enclosing scope.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `let`-bound locals are ordinary VarDecls and live in the block's
// scope; they do not escape the BlockStmt that contains them.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    {
        let inner = 7;
    }
    int x = inner;
//CHECK:    ^^^^^ undefined identifier
//CHECK:    ^^^^^ undefined identifier 'inner'.
// CHECK: E30015
}
