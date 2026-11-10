//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#generic-specialization-and-constraints
//META: purpose=A variadic pack whose element count violates a `countof(...)` constraint is reported as a pack-count mismatch (E30433) rather than a generic catch-all.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the VariadicPackCountMismatch arm of the deferred inference-failure
// report. The call supplies three pack elements where the constraint demands
// two, and the recorded counts are what the lazily formatted message prints.
// CHECK pins E30433 plus the "see declaration" note the arm emits with it.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void takesTwo<each T>(expand each T args) where countof(T) == 2
{
}

void main()
{
    takesTwo(1, 2, 3);
//CHECK: E30433
//CHECK: see declaration of
}
