//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#return-statement
//META: purpose=The returned value is coerced to the function's declared result type.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an int literal returned from a float-typed function is coerced to float.
// The caller receives a float value and can compare it.
//TEST:INTERPRET(filecheck=CHECK):

float toFloat() { return 3; }  // int 3 coerced to float

void main()
{
    float f = toFloat();
    // CHECK: 3
    printf("%d\n", int(f));
}
