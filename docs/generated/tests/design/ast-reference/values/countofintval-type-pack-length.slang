//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#intval-family
//META: purpose=A countof applied to a type pack is a compile-time integer that folds to the number of elements the pack was bound to.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the type-argument form of the compile-time `countof` value.
// `countof(T)` inside the generic is symbolic; the call site binds the
// pack to three arguments, so the returned integer must be 3. CHECK
// asserts the printed count, which is the folded value.

//TEST:INTERPRET(filecheck=CHECK):

int packCount<each T>(expand each T args)
{
    return countof(T);
}

void main()
{
    // CHECK: n=3
    printf("n=%d\n", packCount(1, 2, 3));
}
