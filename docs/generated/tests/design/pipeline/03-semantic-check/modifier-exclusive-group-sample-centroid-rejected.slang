//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#modifier-validation
//META: purpose=The `sample` and `centroid` modifiers share their own conflict group, separate from the other interpolation modifiers, so `sample centroid` on one field is rejected (E31202).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the sampling-location group: `sample` and `centroid` name competing
// sample locations, so the pair is rejected even though neither conflicts with
// an interpolation mode. CHECK pins E31202 and the message naming `centroid`
// against `sample`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct V
{
    sample centroid float4 c : COLOR;
//CHECK: E31202
//CHECK: modifier 'centroid' is redundant or conflicting with existing modifier 'sample'
}

void main()
{
}
