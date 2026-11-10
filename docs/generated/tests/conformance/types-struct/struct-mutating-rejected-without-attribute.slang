//META: generated=true
//META: doc_ref=docs/language-reference/types-struct.md#nonstatic-member-function
//META: purpose=Writing to a non-static data member inside a non-`[mutating]` member function is rejected by the compiler.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that writing to a non-static member field in a non-`[mutating]` function is rejected.
// badWrite() assigns to `a` without the attribute; CHECK-DAG asserts E30011 (l-value) fires.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):

struct TestStruct
{
    int a;

    int badWrite()
    {
        a = 5;
        return a;
    }
}

void main()
{
}

// CHECK-DAG: error
// CHECK-DAG: E30011
// CHECK-DAG: l-value
