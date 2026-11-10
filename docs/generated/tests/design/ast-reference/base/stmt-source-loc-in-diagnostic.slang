//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#stmt-modifiablesyntaxnode
//META: purpose=A Stmt inherits a source location, so a statement-level error is reported at the offending statement's own column.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the other half of what a statement inherits from its base:
// a location. A `break` outside any loop or switch is rejected, and
// the caret span covers the `break` statement where it was written
// rather than the enclosing function. CHECK pins E30003 and the span.

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
