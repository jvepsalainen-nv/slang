//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#assoctypedecl
//META: purpose=An AssocTypeDecl declares an associated type in an interface; the conforming type supplies a concrete alias and dispatch produces that type's value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `associatedtype` inside an interface names a type each
// conformer chooses. The interface's method returns the associated type; the
// conformer aliases it to `int` and returns a field. The CHECK asserts that
// field's value flowing out through the associated-type-typed result.

//TEST:INTERPRET(filecheck=CHECK):

interface IContainer
{
    associatedtype Item;
    Item first();
}

struct IntStream : IContainer
{
    typealias Item = int;
    int firstVal;
    Item first() { return firstVal; }
}

IntStream.Item peek(IntStream s) { return s.first(); }

void main()
{
    IntStream s; s.firstVal = 11;
    //CHECK: 11
    printf("%d\n", peek(s));
}
