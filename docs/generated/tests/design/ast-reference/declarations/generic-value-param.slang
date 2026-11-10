//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A GenericValueParamDecl introduces a compile-time value parameter that the generic body can use as an integer.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `let N : int` generic parameter is a value, not a type: the
// body multiplies by it and the call site supplies a literal. The CHECK
// asserts the product, which requires the substituted value to have reached
// the body.

//TEST:INTERPRET(filecheck=CHECK):

int scaled<let N : int>(int x) { return x * N; }

void main()
{
    //CHECK: 30
    printf("%d\n", scaled<5>(6));
}
