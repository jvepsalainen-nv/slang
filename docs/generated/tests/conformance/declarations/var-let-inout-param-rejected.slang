//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=A `let` variable may not be used as argument for an `inout` parameter; the compiler rejects it with E30047.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `let` variable cannot be passed as an `inout` argument.
// Passing the immutable `x` to `add1(inout int v)` must trigger E30047; CHECK-DAG
// asserts the error severity and code.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

void add1(inout int v) { v += 1; }

void main()
{
    let x = 5;
    add1(x);
}

// CHECK-DAG: error
// CHECK-DAG: E30047
