//META: generated=true
//META: doc_ref=docs/language-reference/expressions-identifier.md#identifier-expressions
//META: purpose=An identifier expression is an l-value when the declaration it refers to is mutable, allowing assignment and inout passing.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// When the identifier refers to a mutable local variable, it is an l-value and can be assigned.
// This tests both direct assignment and passing as an `inout` argument.
//TEST:INTERPRET(filecheck=CHECK):

void increment(inout int v) { v = v + 1; }

void main()
{
    int x = 10;
    // 'x' is a mutable local — the identifier expression 'x' is an l-value.
    x = 20;             // direct assignment through identifier l-value
    increment(x);       // passing identifier l-value as inout
    //CHECK: 21
    printf("%d\n", x);
}
