//META: generated=true
//META: doc_ref=docs/language-reference/expressions-initializer.md#initializer-list-expression
//META: purpose=A zero-element initializer list {} is a valid initializer list expression (zero or more expressions).
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower boundary of the initializer list element count: zero elements.
// An empty struct initialized with `{}` must compile and produce a usable instance.
// CHECK asserts "ok" is printed, confirming the zero-element initializer list was
// accepted and execution reached past the declaration.

//TEST:INTERPRET(filecheck=CHECK):

struct Empty {};

void main()
{
    Empty e = {};
    // If we reach here without a crash, the zero-element init list was accepted.
    //CHECK: ok
    printf("ok\n");
}
