//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#inputs-and-outputs
//META: purpose=After checking, every DeclRef-bearing node points at the canonical decl, so a call written before the callee's declaration still resolves to it.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "names resolved" half of the checker's output contract. The
// call to `later()` is written textually before `later` is declared, so it
// can only resolve if name binding runs over the whole translation unit and
// rewrites the reference to point at the one canonical decl. CHECK asserts
// the value that only `later`'s body can produce.

//TEST:INTERPRET(filecheck=CHECK):

int forwardUse()
{
    return later();
}

int later()
{
    return 7;
}

void main()
{
    // CHECK: v=7
    printf("v=%d\n", forwardUse());
}
