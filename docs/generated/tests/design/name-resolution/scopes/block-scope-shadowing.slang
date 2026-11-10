//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-walking-order-during-lookup
//META: purpose=Visiting `currentScope` first means an inner declaration with the same name as an outer one shadows it inside the inner block.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Step 1 of the documented walk is "visit currentScope itself ...".
// An inner `int x` therefore shadows an outer `int x` for the
// duration of the inner block, and the outer is restored on exit.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int x = 1;
    {
        int x = 2;
        // CHECK: inner=2
        printf("inner=%d\n", x);
    }
    // CHECK: outer=1
    printf("outer=%d\n", x);
}
