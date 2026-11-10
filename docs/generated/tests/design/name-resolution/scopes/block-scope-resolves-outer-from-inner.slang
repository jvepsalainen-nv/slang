//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#scope-walking-order-during-lookup
//META: purpose=Lookup walks to the parent scope when a name is not found in the current scope; an inner block can see an enclosing block's local.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Step 3 of the documented walk is "move to currentScope->parent and
// repeat". An inner block must therefore see names declared in an
// enclosing block.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int outer = 10;
    {
        int doubled = outer * 2;
        // CHECK: doubled=20
        printf("doubled=%d\n", doubled);
    }
}
