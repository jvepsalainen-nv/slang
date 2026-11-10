//META: generated=true
//META: doc_ref=docs/language-reference/statements.md#declaration-statement
//META: purpose=Variable declarations using let, var, and typed form are valid in statement context.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that let, var, and typed variable declarations are all valid statements.
// Each form declares a variable and its value is observable via printf.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    let x = 10;
    var y = x + 1;
    int z = y - x;
    // CHECK: 10
    printf("%d\n", x);
    // CHECK: 11
    printf("%d\n", y);
    // CHECK: 1
    printf("%d\n", z);
}
