//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#astypeexpr--istypeexpr--casttosupertypeexpr
//META: purpose=A CastToSuperTypeExpr is inserted when a concrete struct is passed where an interface is expected; the interface method dispatches to the concrete implementation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that passing a concrete struct where an interface parameter is
// expected inserts the up-cast that carries the conformance witness. The
// callee invokes the interface method; the CHECK asserts the concrete type's
// own implementation ran, which requires the witness to have been threaded.

//TEST:INTERPRET(filecheck=CHECK):

interface IShape { int area(); }
struct Sq : IShape { int s; int area() { return s * s; } }

int describe(IShape shape) { return shape.area(); }

void main()
{
    Sq sq = {5};
    // CHECK: a=25
    printf("a=%d\n", describe(sq));
}
