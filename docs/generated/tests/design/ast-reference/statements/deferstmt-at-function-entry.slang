//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#deferstmt
//META: purpose=A DeferStmt placed at function entry has the entire function body as its surrounding scope; the deferred inner statement runs after every other statement in the function but before the caller resumes.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: defer at the top of a function body. The enclosing
// scope is the function body itself, so the defer fires when the
// function returns. The caller must observe the deferred print
// before the post-call print.

//TEST:INTERPRET(filecheck=CHECK):

void worker()
{
    defer printf("worker-cleanup\n");
    printf("worker-step1\n");
    printf("worker-step2\n");
}

void main()
{
    worker();
    printf("main-after\n");
    // CHECK: worker-step1
    // CHECK-NEXT: worker-step2
    // CHECK-NEXT: worker-cleanup
    // CHECK-NEXT: main-after
}
