//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#deferstmt
//META: purpose=`defer` takes a single statement, so a deferred block is written without a trailing semicolon and the whole block is what gets deferred.
//META: intent=boundary
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the block form `defer { ... }` (no trailing `;`) parses and
// that both statements inside the block are deferred together, not just
// the first. The CHECKs assert the block body's own print comes first,
// then both deferred prints in source order, then the statement after
// the enclosing scope.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    {
        defer { printf("d-a\n"); printf("d-b\n"); }
        printf("body\n");
    }
    printf("after\n");
    // CHECK: body
    // CHECK-NEXT: d-a
    // CHECK-NEXT: d-b
    // CHECK-NEXT: after
}
