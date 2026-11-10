//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#thistype-and-assoctypedecl
//META: purpose=A ThisType stands for the conforming type inside a polymorphic declaration, so a method returning `This` yields the concrete type when dispatched.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `This` is substituted with the conforming type rather
// than erased to the interface: the generic stores the result of a
// This-returning method in a `T` local and then calls a further
// requirement on it. CHECK asserts the cloned mark, which needs the
// returned value to have been typed as the concrete conformer.

//TEST:INTERPRET(filecheck=CHECK):

interface ICloneable
{
    This makeClone();
    int getMark();
}

struct Widget : ICloneable
{
    int mark;
    This makeClone() { Widget w; w.mark = this.mark + 100; return w; }
    int getMark() { return mark; }
}

int cloneAndRead<T : ICloneable>(T v)
{
    T c = v.makeClone();
    return c.getMark();
}

void main()
{
    Widget w;
    w.mark = 5;
    // CHECK: m=105
    printf("m=%d\n", cloneAndRead(w));
}
