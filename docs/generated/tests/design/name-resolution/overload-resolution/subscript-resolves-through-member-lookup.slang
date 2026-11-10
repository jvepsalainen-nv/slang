//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#the-general-path
//META: purpose=__subscript is resolved by member lookup on the indexed value's type, so a[i] dispatches to the type's subscript getter with the implicit this.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second member-lookup operator form. Indexing a struct value
// resolves __subscript on its type and replays the this breadcrumb, so the
// getter can read the receiver's field; CHECK asserts a result that combines
// the stored base with the index.

//TEST:INTERPRET(filecheck=CHECK):

struct Grid
{
    int base;
    __subscript(int i) -> int { get { return base + i; } }
}

void main()
{
    Grid g;
    g.base = 100;
    int tag = g[7];
    // CHECK: tag=107
    printf("tag=%d\n", tag);
}
