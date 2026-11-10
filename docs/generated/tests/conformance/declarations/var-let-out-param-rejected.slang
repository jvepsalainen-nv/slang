//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=A `let` variable may not be used as argument for an `out` parameter; the compiler rejects it with E30047.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `let` variable cannot be passed as an `out` argument.
// Passing immutable `x` to `fill(out int v)` must trigger E30047; CHECK-DAG
// confirms both the error severity and the diagnostic code.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

void fill(out int v) { v = 99; }

void main()
{
    let x = 0;
    fill(x);
}

// CHECK-DAG: error
// CHECK-DAG: E30047
