//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=A `let` declaration introduces an immutable variable whose value is observable but cannot be assigned to.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `let` variable is readable and holds its initialized value.
// Both `let x = 7` (inferred type) and `let y : int = 42` (explicit type) are printed;
// CHECK lines assert the correct values, confirming both forms bind and retain their values.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    let x = 7;
    let y : int = 42;
    // CHECK: 7
    // CHECK: 42
    printf("%d\n%d\n", x, y);
}
