//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=An `[open]` interface accepts implementations and dispatches through an interface-typed parameter.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the inheritance-control attribute's role on the permissive side:
// marking the interface `[open]` still leaves it implementable and usable as an
// existential parameter type. A struct conforms and is passed to a function
// taking the interface; CHECK asserts the conformer's own method result comes
// back, so the dispatch really went through the interface.

//TEST:INTERPRET(filecheck=CHECK):

[open]
interface IShape
{
    int sides();
}

struct Triangle : IShape
{
    int sides() { return 3; }
}

int countSides(IShape s)
{
    return s.sides();
}

void main()
{
    Triangle t;
    //CHECK: sides=3
    printf("sides=%d\n", countSides(t));
}
