//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#interaction-with-extern-and-export
//META: purpose=The bare `export` keyword records linkage intent and does not raise a decl's visibility, so an `export`-marked struct is still only `internal` to the visibility checker.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `export` and the `public`/`internal`/`private` family are
// independent axes. `IS` is marked `export` but carries no visibility
// modifier, so it keeps the module default `internal`. If `export` promoted
// it to `public`, the `public` function naming `IS` would check cleanly; the
// CHECK pins the E30604 less-visible-type rejection that proves the
// classification was unchanged.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

export struct IS { int v; }

public IS makeIS(IS s) { return s; }
//CHECK:  ^^^^^^ references less visible type
//CHECK:  ^^^^^^ 'makeIS' references less visible type 'IS'.
// CHECK: E30604
