//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#edge-cases-and-failure-modes
//META: purpose=`private` on a top-level decl (no enclosing aggregate or namespace) is rejected with `invalid-use-of-private-visibility`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Edge case: `private` only makes sense inside a container. A
// top-level struct declared `private` fires diagnostic 30603.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

private struct TopLevel
/*CHECK:
^^^^^^^ invalid private visibility
^^^^^^^ 'TopLevel' cannot have private visibility because it is not a member of a type.
*/
// CHECK: E30603
{}
