//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An InitializerListExpr with more elements than the aggregate has fields is rejected with a "too many initializers" diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative shape for InitializerListExpr count-mismatch on the
// upper side: a 3-field struct receives 5 elements; the checker
// must diagnose the overflow.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct R { int a; int b; int c; }

void main()
{
    R r = {1, 2, 3, 4, 5};
//CHECK:  ^ too many initializers in initializer list
//CHECK:  ^ too many initializers (expected 3, got 5)
// CHECK: E30523
}
