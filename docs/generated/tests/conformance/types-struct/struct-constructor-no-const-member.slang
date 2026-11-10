//META: generated=true
//META: doc_ref=docs/language-reference/types-struct.md#constructor
//META: purpose=`const` data members cannot be initialized by the constructor; attempting to assign to a `const` field inside `__init` is a compiler error.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that assigning to a `const` data member inside a `__init` body is rejected.
// The diagnostic test compiles HasConst whose __init tries to write `c`; CHECK-DAG
// asserts the compiler emits an E30011 l-value error.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):

struct HasConst
{
    const int c = 5;

    __init(int v)
    {
        c = v;
    }
}

void main()
{
}

// CHECK-DAG: error
// CHECK-DAG: E30011
// CHECK-DAG: l-value
