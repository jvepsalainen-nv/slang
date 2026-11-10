//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#variables
//META: purpose=A `var` with an explicit type but no initializer is allowed; the variable is uninitialized until explicitly assigned.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `var x : int` (explicit type, no initializer) compiles and is writable.
// After declaring without an initializer, `x` is assigned 55; 55 confirms the
// variable was live and held the assigned value.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    var x : int;
    x = 55;
    // CHECK: 55
    printf("%d\n", x);
}
