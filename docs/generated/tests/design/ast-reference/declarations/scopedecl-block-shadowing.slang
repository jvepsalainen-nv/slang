//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#nodes
//META: purpose=A ScopeDecl is the anonymous scope the parser creates for a block statement; a name declared inside shadows the outer one only within the block.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a nested block introduces its own scope. The same name is
// declared inside and outside a block with different values; the CHECK
// asserts the inner value while inside and the outer value afterwards, which
// requires the block to have its own scope rather than reusing the function's.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 1;
    {
        int x = 2;
        //CHECK: inner=2
        printf("inner=%d\n", x);
    }
    //CHECK: outer=1
    printf("outer=%d\n", x);
}
