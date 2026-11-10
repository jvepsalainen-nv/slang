//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#initializers
//META: purpose=An `__init` has access to an implicit mutable `this` parameter representing the instance being initialized.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an `__init` body can write fields via the implicit mutable `this`.
// `Point(7, 13)` assigns through `this.x` and `this.y`; CHECK lines assert 7 and 13,
// confirming that `this` was writable and the assignments persisted to the caller.

//TEST:INTERPRET(filecheck=CHECK):

struct Point
{
    int x, y;
    __init(int px, int py)
    {
        this.x = px;
        this.y = py;
    }
}

void main()
{
    Point p = Point(7, 13);
    // CHECK: 7
    // CHECK: 13
    printf("%d\n%d\n", p.x, p.y);
}
