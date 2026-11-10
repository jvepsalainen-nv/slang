//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-2 prefix/unary operators are right-associative: `!!a` groups as `!(!a)` as shown in the doc example.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that prefix/unary operators at level 2 are right-associative.
// `!!a` groups as `!(!a)`: double-negation of true is true, of false is false.
// CHECK-DAG asserts r1=1 for `!!true` and r2=0 for `!!false`, confirming that
// each `!` applies to the result of the inner `!`, not to a partially-evaluated left side.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    // Use inline bool variables to avoid slangi bool-parameter passing quirk
    bool t = true;
    bool f = false;
    int r1 = !!t ? 1 : 0;
    int r2 = !!f ? 1 : 0;
    // CHECK-DAG: unary-right-assoc: r1=1
    // CHECK-DAG: unary-right-assoc: r2=0
    printf("unary-right-assoc: r1=%d\n", r1);
    printf("unary-right-assoc: r2=%d\n", r2);
}
