//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#edge-cases-and-failure-modes
//META: purpose=ExtensionDecl members are reachable only via member lookup on the extended type, never as unqualified file-scope names.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "ExtensionDecl members are not in the extension's scope chain"
// edge case: from outside Point's member-lookup, `manhattan` is not
// visible by unqualified name even though an extension provides it.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Point { int x; int y; }

extension Point {
    int manhattan() { return x + y; }
}

void main()
{
    Point p = {3, 5};
    int m = manhattan();
//CHECK:    ^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^ undefined identifier 'manhattan'.
// CHECK: E30015
}
