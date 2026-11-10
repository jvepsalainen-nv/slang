//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#edge-cases-and-failure-modes
//META: purpose=A sibling of the outer decl that mentions a generic type parameter cannot reach it; its scope chain does not pass through the GenericDecl.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "GenericDecl parameter scope vs inner-decl scope" edge case:
// `T` is only in scope inside the generic's body. A sibling free
// function declared at file scope cannot see `T`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

T gen<T>(T x) { return x; }

void other()
{
    T y;
/*CHECK:
    ^ undefined identifier
    ^ undefined identifier 'T'.
*/
// CHECK: E30015
}
