//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#synthesizing-implicit-code
//META: purpose=An initializer list with more elements than the synthesized constructor accepts is rejected with E30523 naming both counts.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the boundary of the synthesized construction signature: the
// synthesized constructor has exactly one parameter per field, so a third
// initializer for a two-field struct has nowhere to bind. CHECK pins E30523,
// whose message carries the expected and actual counts.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S
{
    int a;
    int b;
}

void main()
{
    S s = { 1, 2, 3 };
//CHECK: E30523
}
