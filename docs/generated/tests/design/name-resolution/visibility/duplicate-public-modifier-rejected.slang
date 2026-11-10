//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/visibility.md#edge-cases-and-failure-modes
//META: purpose=A repeated visibility keyword (`public public`) is caught by the conflict-group check as `duplicate-modifier` (31202), not by the 36005 invalid-placement path.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a repeated visibility keyword routes to the duplicate-modifier
// conflict-group rejection rather than the invalid-placement diagnostic.
// The CHECKs pin E31202 on the `public public` declaration; each
// duplicate-modifier diagnostic emits a title row and a span row, both
// carrying the code, so both rows are matched.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

public public int twice() { return 2; }
//CHECK: E31202
//CHECK: E31202
