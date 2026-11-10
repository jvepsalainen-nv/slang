//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#visibility-modifiers-and-language-version
//META: purpose=A `public` member is accessible from outside its enclosing type and a `public` function from anywhere.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `public` is the widening counterpart of `private`: both the fields
// and the free function carrying it are reachable from ordinary code. The fields
// are written and summed through a `public` function; CHECK asserts 12, which
// requires every one of those accesses to have passed the visibility check.

//TEST:INTERPRET(filecheck=CHECK):

public struct Pt
{
    public int x;
    public int y;
}

public int sumPt(Pt p)
{
    return p.x + p.y;
}

void main()
{
    Pt p;
    p.x = 5;
    p.y = 7;
    //CHECK: sum=12
    printf("sum=%d\n", sumPt(p));
}
