//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#genericdecl
//META: purpose=An interface member written with a body becomes a default implementation that a conformer inherits without redeclaring it.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the default-implementation form of an interface member. The
// interface declares `perimeter()` with a body that calls the abstract
// `area()`; the conforming struct implements only `area()`. Calling
// `perimeter()` through a constrained generic must run the interface's body
// against the conformer's `area()`, which the CHECK's value pins down.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape
{
    int area();
    int perimeter() { return area() * 4; }
}

struct Sq : IShape
{
    int s;
    int area() { return s * s; }
}

int perimeterOf<T : IShape>(T t) { return t.perimeter(); }

void main()
{
    Sq q; q.s = 3;
    //CHECK: 36
    printf("%d\n", perimeterOf(q));
}
