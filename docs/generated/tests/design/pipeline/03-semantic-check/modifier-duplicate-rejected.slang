//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#modifier-validation
//META: purpose=Modifier validation rejects a redundant repetition of the same modifier on one declaration (E31202).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "mutually exclusive / redundant combinations" rule. Repeating
// `static` on one declaration is not additive, so the second occurrence is
// reported against the first. CHECK pins E31202 on the repeated modifier.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

static static int g = 1;
//CHECK: E31202

void main()
{
}
