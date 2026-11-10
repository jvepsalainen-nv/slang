//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#container-level-cap
//META: purpose=A `public` function whose return type is less-visible (an `internal` struct) is rejected with `use-of-less-visible-type`.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Container-level cap: a decl cannot reference a type that is less
// visible than itself. `IS` is `internal` (modern default); a public
// function returning it fires diagnostic 30604.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct IS {}

public IS makeIS() {}
//CHECK:  ^^^^^^ references less visible type
//CHECK:  ^^^^^^ 'makeIS' references less visible type 'IS'.
// CHECK: E30604
