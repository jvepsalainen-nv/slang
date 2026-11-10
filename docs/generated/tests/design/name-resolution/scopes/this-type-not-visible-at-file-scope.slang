//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=The ThisTypeDecl belongs to its InterfaceDecl's scope only, so `This` is undefined in a function at file scope.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the boundary of the synthesized `This` member: it is a member of
// the interface that owns it, never a name pushed onto the surrounding
// scope chain. A free function at file scope declares a `This` local; the
// annotated E30015 at that spelling proves the name did not leak out of the
// interface declared just above it. The compiler's near-spelling suggestion
// (`this`) is annotated on the same span.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

interface IThing
{
    int value();
}

void main()
{
    This v;
/*CHECK:
    ^^^^ undefined identifier
    ^^^^ undefined identifier 'This'.
    ^^^^ did you mean 'this'?
*/
// CHECK: E30015
    printf("%d\n", 0);
}
