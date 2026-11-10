//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#where-keywords-come-from
//META: purpose=Negative: `int` is a core-module type name; once a local named `int` exists, the parser still treats a subsequent leading `int` in a declaration as the type token, so `int x = int + 1;` is rejected because the parser cannot reuse the type name as a value expression.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Probes the keyword-vs-identifier boundary for the core-module type
// name `int`. The local `int int = 5;` parses (decl context binds the
// identifier), but a follow-up declaration that needs `int` to be a
// type token at the head still wins over identifier lookup.

//DIAGNOSTIC_TEST:SIMPLE(filecheck=CHECK,exit-code=-1):

void main()
{
    int int = 5;
    int x = int + 1;
    // CHECK-DAG: error
    // CHECK-DAG: expected a type
// CHECK-DAG: E30060
    printf("%d\n", x);
}
