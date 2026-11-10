//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#modifier-validation
//META: purpose=The `pervertex` modifier shares the interpolation conflict group with `nointerpolation`, `noperspective` and `linear`, so `pervertex linear` on one field is rejected (E31202).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the refreshed group membership: `pervertex` is a member of the
// first interpolation group, so it conflicts with `linear` just as
// `nointerpolation` does. CHECK pins E31202 and the message naming `linear`
// against `pervertex`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct V
{
    pervertex linear float4 c : COLOR;
//CHECK: E31202
//CHECK: modifier 'linear' is redundant or conflicting with existing modifier 'pervertex'
}

void main()
{
}
