//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=It is an error to declare a variable with neither a type specifier nor an initial-value expression; compiler emits E30620.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `var x;` with neither a type nor an initializer is a compile error.
// The compiler must emit E30620; CHECK-DAG lines assert the error severity and code.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK, exit-code=-1):

void main()
{
    var x;
}

// CHECK-DAG: error
// CHECK-DAG: E30620
