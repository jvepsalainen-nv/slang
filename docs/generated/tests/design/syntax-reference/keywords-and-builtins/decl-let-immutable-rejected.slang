//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=A binding introduced by `let` is immutable; assignment to a let-bound name is a compile-time error.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative test: writing to a `let`-bound name must be rejected by
// the compiler. The diagnostic mentions that the left-hand side is
// not an l-value.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):

void main()
{
    let x = 7;
    x = 8;
    // CHECK-DAG: error
    // CHECK-DAG: l-value
    // CHECK-DAG: E30011
}
