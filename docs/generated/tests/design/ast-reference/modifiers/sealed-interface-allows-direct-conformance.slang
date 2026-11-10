//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=A `[sealed]` interface can still be implemented directly by a type in the same module.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The contrast case for `[open]`: `[sealed]` is the other member of the
// inheritance-control pair, and it constrains further inheritance rather than
// forbidding conformance outright. A struct implements the sealed interface and
// CHECK asserts its method result, showing the attribute is accepted and does not
// block a direct implementation.

//TEST:INTERPRET(filecheck=CHECK):

[sealed]
interface IShape
{
    int sides();
}

struct Quad : IShape
{
    int sides() { return 4; }
}

void main()
{
    Quad q;
    //CHECK: sides=4
    printf("sides=%d\n", q.sides());
}
