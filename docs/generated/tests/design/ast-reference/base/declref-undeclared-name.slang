//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#val-nodebase
//META: purpose=A use of a name must resolve to a declaration before a DeclRefBase can be formed; when no reachable declaration matches, the checker reports an undefined identifier.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the negative side of decl-ref formation: an identifier with
// no matching declaration in any reachable scope cannot become a
// reference, and the checker says so. CHECK pins the E30015 code and
// the caret span covering the whole unresolved name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int v = doesNotExistAnywhere();
//CHECK:    ^^^^^^^^^^^^^^^^^^^^ undefined identifier
//CHECK:    ^^^^^^^^^^^^^^^^^^^^ undefined identifier 'doesNotExistAnywhere'.
// CHECK: E30015
}
