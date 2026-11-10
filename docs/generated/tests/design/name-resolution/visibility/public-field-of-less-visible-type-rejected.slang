//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#container-level-cap
//META: purpose=A `public` field of a less-visible (internal) struct type inside a `public` aggregate is rejected with `use-of-less-visible-type`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Container-level cap: the public field `member` references the
// internal type `IS`, so `checkVisibility` rejects with 30604.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct IS {}

public struct PS
{
    public IS member;
//CHECK:      ^^^^^^ references less visible type
//CHECK:      ^^^^^^ 'member' references less visible type 'IS'.
// CHECK: E30604
}
