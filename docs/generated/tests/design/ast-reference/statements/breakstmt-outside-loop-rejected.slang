//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#labelstmt-breakstmt-continuestmt-and-discardstmt
//META: purpose=A BreakStmt is a ChildStmt whose target must be an enclosing BreakableStmt (loop or switch); used outside any such enclosing statement it is rejected.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `break` requires an enclosing loop or switch to jump out of.
// With no such enclosing statement, checking has nothing to match the
// jump against; the CHECK pins the E30003 diagnostic on the `break`
// token itself.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    break;
/*CHECK:
    ^^^^^ 'break' must appear inside loop or switch constructs
    ^^^^^ 'break' must appear inside loop or switch constructs.
*/
// CHECK: E30003
}
