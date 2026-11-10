//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=ExtensionDecl owns a scope; the extended type's member-lookup finds the extension method when called via the receiver.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ExtensionDecl is listed as scope-bearing. The extension's members
// are not in the enclosing file scope, but member lookup on the
// extended type reaches them.

//TEST:INTERPRET(filecheck=CHECK):

struct Point { int x; int y; }

extension Point {
    int manhattan() { return x + y; }
}

void main()
{
    Point p = {3, 5};
    int m = p.manhattan();
    // CHECK: m=8
    printf("m=%d\n", m);
}
