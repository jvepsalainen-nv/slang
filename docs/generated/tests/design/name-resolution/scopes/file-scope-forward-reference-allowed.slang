//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#edge-cases-and-failure-modes
//META: purpose=The block-local `hiddenFromLookup` rule does not apply at file scope; a function may refer to another function declared later in the same file.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Empty block scope" edge case explicitly scopes the
// hiddenFromLookup mechanic to block-locals. File-scope decls are not
// hidden by it, so a forward reference between top-level functions
// is allowed.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int v = producer();
    // CHECK: v=99
    printf("v=%d\n", v);
}

int producer() { return 99; }
