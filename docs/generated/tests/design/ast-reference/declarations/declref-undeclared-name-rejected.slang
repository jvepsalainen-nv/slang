//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#unresolveddecl
//META: purpose=A reference to a name with no matching declaration in scope is diagnosed rather than silently bound to a placeholder declaration.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an unbound name produces a user-facing diagnostic. The doc
// records that nothing in the tree constructs the placeholder declaration
// class, so the only observable outcome of a failed name binding is the
// E30015 error the CHECK pins.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = noSuchNameZzz;
//CHECK: error
//CHECK: E30015
}
