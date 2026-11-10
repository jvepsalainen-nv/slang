//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=Assigning to a `let` variable is rejected by the compiler with E30011 (not an l-value).
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that assigning to a `let` variable is rejected as not an l-value.
// `x = 10` after `let x = 5` must produce E30011; CHECK-DAG lines assert both
// the error severity, the code, and the "l-value" message fragment.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

void main()
{
    let x = 5;
    x = 10;
}

// CHECK-DAG: error
// CHECK-DAG: E30011
// CHECK-DAG: l-value
