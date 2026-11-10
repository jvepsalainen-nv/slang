//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#files-and-responsibilities
//META: purpose=Statement checking enforces control-flow scope rules: `break` with no enclosing loop or switch is rejected with E30003.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "control flow, scope rules" concern of statement checking. The
// `break` has no enclosing breakable construct, a fact only the statement
// walk knows; CHECK pins E30003 on the keyword.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void main()
{
    break;
//CHECK: E30003
}
