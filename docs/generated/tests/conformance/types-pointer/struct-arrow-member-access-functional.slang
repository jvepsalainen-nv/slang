//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=For a pointer to a struct, `p->member` and `(*p).member` both access the same struct member; mutation through `->` is visible in the original.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `p->member` and `(*p).member` both access the same struct field.
// Takes a pointer to a `Vec2`, mutates `p->x`, then reads both fields via both
// syntaxes; CHECK asserts the updated and untouched fields have the expected values,
// confirming arrow-access and dot-dereference are equivalent.
//TEST:INTERPRET(filecheck=CHECK):

struct Vec2
{
    int x;
    int y;
}

void main()
{
    Vec2 v;
    v.x = 11;
    v.y = 22;
    Vec2* p = &v;
    p->x = 99;
    //CHECK: 99 22
    printf("%d %d\n", p->x, (*p).y);
}
