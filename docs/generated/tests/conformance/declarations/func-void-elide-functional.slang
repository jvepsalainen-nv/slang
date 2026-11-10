//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#body
//META: purpose=If the function result type is `void`, the result type clause may be elided from a `func` declaration.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `func` with a void result can omit the `-> void` clause entirely.
// `doNothing` compiles and runs without an arrow clause; ok confirms execution
// reached the printf, proving the elided result type is accepted.

//TEST:INTERPRET(filecheck=CHECK):

func doNothing(x: int) { }

void main()
{
    doNothing(5);
    // CHECK: ok
    printf("ok\n");
}
