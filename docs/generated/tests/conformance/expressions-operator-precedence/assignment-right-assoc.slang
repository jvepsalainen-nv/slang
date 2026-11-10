//META: generated=true
//META: doc_ref=docs/language-reference/expressions-operator-precedence.md#operator-precedence
//META: purpose=Level-14 `=` is right-associative: `a = b = 5` groups as `a = (b = 5)` — both a and b become 5.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `=` at precedence level 14 is right-associative.
// `a = b = 5` must group as `a = (b = 5)`, leaving both variables equal to 5.
// A left-associative reading `(a = b) = 5` would also produce a=5, b=0, which
// CHECK-DAG rules out by asserting both a=5 and b=5.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a = 0;
    int b = 0;
    a = b = 5;
    // CHECK: assignment-right-assoc: a=5 b=5
    printf("assignment-right-assoc: a=%d b=%d\n", a, b);
}
