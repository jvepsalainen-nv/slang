//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#where-visibility-is-filtered
//META: purpose=A `private` method of struct A is not visible from a method of an unrelated struct B; `isDeclVisibleFromScope` walks B's parents and never finds A.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `isDeclVisibleFromScope` for `Private` checks whether the
// requesting scope's parent chain contains A's enclosing aggregate.
// Two unrelated structs are not in each other's parent chain, so
// access is rejected.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct A
{
    private int secret() { return 1; }
}

struct B
{
    int peek(A a) { return a.secret(); }
//CHECK:                     ^^^^^^ declaration not accessible
//CHECK:                     ^^^^^^ 'secret' is not accessible from the current context.
// CHECK: E30600
}
