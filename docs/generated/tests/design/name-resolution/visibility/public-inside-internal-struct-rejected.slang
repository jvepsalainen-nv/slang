//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#edge-cases-and-failure-modes
//META: purpose=A `public` member inside an `internal` aggregate is rejected by `checkVisibility` with `decl-cannot-have-higher-visibility`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Edge case: a `public` member of a non-public container fires
// diagnostic 30601 (`decl-cannot-have-higher-visibility`). The
// surrounding struct is `internal` (the modern default).

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Container
{
    public void leak() {}
//CHECK:        ^^^^ visibility higher than parent
//CHECK:        ^^^^ 'leak' cannot have a higher visibility than 'Container'.
// CHECK: E30601
}
