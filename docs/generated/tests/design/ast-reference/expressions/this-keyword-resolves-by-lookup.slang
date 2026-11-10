//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#type-expression-family-pointertypeexpr-functypeexpr-tupletypeexpr-andtypeexpr-modifiedtypeexpr-packbranchtypeexpr
//META: purpose=A written `This` is an ordinary name resolved by lookup, not a dedicated type-expression node; a requirement returning `This` binds to each conformer's own type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `This` behaves like any other name in type position: it is
// looked up in the enclosing scope and resolves to the surrounding type
// rather than being a special keyword form. An interface requirement returns
// `This`; the implementation returns its own struct type and the result is
// used as that concrete type, so the CHECK only matches if the lookup bound
// `This` to the conformer.

//TEST:INTERPRET(filecheck=CHECK):

interface ICloneable
{
    This clone();
    int tag();
}

struct A : ICloneable
{
    int v;
    This clone() { A r = { v + 1 }; return r; }
    int tag() { return v; }
}

void main()
{
    A a = {10};
    A b = a.clone();
    // CHECK: t=11
    printf("t=%d\n", b.tag());
}
