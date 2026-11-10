//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=A `var` declaration introduces a mutable variable that can be assigned after declaration.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `var` introduces a mutable variable that can be reassigned after declaration.
// Both `x` and `y` are assigned new values after initial declaration; CHECK lines assert
// the updated values 42 and 3, confirming mutability for both inferred and explicit types.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    var x = 9;
    var y : float = 1.5;
    x = 42;
    y = 3.0;
    // CHECK: 42
    // CHECK: 3
    printf("%d\n%g\n", x, y);
}
