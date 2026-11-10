//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/base.md#modifiablesyntaxnode-syntaxnode
//META: purpose=The modifier list a ModifiableSyntaxNode owns is consulted during checking, so a mutating member function is permitted to write through this while a plain one is not.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a modifier stored on a declaration changes how that
// declaration is checked, rather than merely being parsed and kept.
// `setTo` is marked `[mutating]` and assigns to a field of `this`;
// CHECK asserts the write is visible to the caller afterwards, which
// requires the checker to have found the modifier on the method decl.

//TEST:INTERPRET(filecheck=CHECK):

struct Box
{
    int v;

    [mutating]
    void setTo(int newV)
    {
        v = newV;
    }
};

void main()
{
    Box b;
    b.v = 0;
    b.setTo(42);
    //CHECK: v=42
    printf("v=%d\n", b.v);
}
