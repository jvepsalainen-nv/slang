//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A ScopeDecl also covers a loop header, so a variable declared there is not visible after the loop.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the loop header gets its own scope rather than leaking into
// the enclosing function. The loop variable is referenced after the loop; the
// CHECK pins the undefined-identifier diagnostic, which is the observable
// consequence of the header scope having ended.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    for (int i = 0; i < 3; ++i) { }
    int y = i;
//CHECK:    ^ undefined identifier
//CHECK:    ^ undefined identifier 'i'.
}
