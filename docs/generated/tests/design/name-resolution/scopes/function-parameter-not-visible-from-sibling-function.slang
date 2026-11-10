//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-bearing-ast-nodes
//META: purpose=A function parameter lives in its owning CallableDecl's scope; a sibling function cannot see it.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `square`'s parameter `n` lives in square's scope only. `main`'s
// scope chain does not pass through square's scope, so `n` is not
// resolvable from main.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

int square(int n) { return n * n; }

void main()
{
    int r = square(7);
    int s = n;
//CHECK:    ^ undefined identifier
//CHECK:    ^ undefined identifier 'n'.
// CHECK: E30015
}
