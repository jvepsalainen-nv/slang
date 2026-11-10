//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A VarDecl's initializer expression populates the variable's storage before first use.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a variable declaration's initializer expression reaches
// runtime rather than being dropped in favour of default zero-initialization.
// The CHECK asserts the literal 17, which is only observable if the
// declaration carried its initializer through checking and lowering.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 17;
    //CHECK: 17
    printf("%d\n", x);
}
