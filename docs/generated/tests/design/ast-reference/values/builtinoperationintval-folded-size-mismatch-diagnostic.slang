//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#builtinoperationintval-and-the-single-representation-invariant
//META: purpose=After substitution the checker reasons with the folded constant rather than the symbolic division, so a size mismatch against an int[N / 2] member is reported with the folded bound.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that once N = 9 is substituted, the member's array bound is
// the folded constant 4 and not a residual symbolic value: the
// mismatch diagnostic names 'int[4]', and the pinned E30019 confirms
// the checker rejected the cross-size initialization.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Half<let N : int>
{
    int data[N / 2];
}

void main()
{
    Half<9> h;
    int five[5] = h.data;
//CHECK: got 'int[4]'
//CHECK: E30019
}
