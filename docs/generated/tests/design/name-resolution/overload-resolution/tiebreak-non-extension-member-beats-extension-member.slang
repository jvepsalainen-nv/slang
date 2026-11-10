//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#tie-breaking-comparator
//META: purpose=CompareLookupResultItems prefers a declaration in the type itself over an equally-applicable member contributed by an extension.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the "non-extension decl over an extension member" arm of the
// lookup-result comparison. Both `act` declarations accept the call with
// identical cost, so the tie is broken purely by where each was declared.
// CHECK asserts the struct-body member's tag.

//TEST:INTERPRET(filecheck=CHECK):

struct S { int act(int x) { return 1; } }

extension S { int act(int x) { return 2; } }

void main()
{
    S s;
    int tag = s.act(1);
    // CHECK: tag=1
    printf("tag=%d\n", tag);
}
