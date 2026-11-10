//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#inheritancedecl
//META: purpose=An InterfaceDecl declares an interface and an inheritance clause ties a conforming type to it; constrained dispatch picks the conformer's implementation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `: IShape` clause on a struct records the conformance that
// generic dispatch relies on. The generic calls the interface's method on its
// parameter and the CHECK asserts the struct's own implementation ran, which
// requires the inheritance clause's witness to have been resolved.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape { int area(); }

struct Square : IShape
{
    int side;
    int area() { return side * side; }
}

int dispatchedArea<T : IShape>(T s) { return s.area(); }

void main()
{
    Square s; s.side = 6;
    //CHECK: 36
    printf("%d\n", dispatchedArea(s));
}
