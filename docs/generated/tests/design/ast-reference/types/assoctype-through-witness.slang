//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#thistype-and-assoctypedecl
//META: purpose=An associated type has no dedicated type class of its own: `T.Elem` is an ordinary decl-ref type reached through the conformance witness, and it resolves to the conformer's chosen type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an associated type behaves as a normal named type once
// the conformance is known: the generic declares a local of type
// `T.Elem` and calls a method that only the conformer's chosen element
// type provides. CHECK asserts the value produced by that concrete
// element, so an associated type that stayed abstract would not compile
// or would dispatch elsewhere.

//TEST:INTERPRET(filecheck=CHECK):

interface IArith { int toInt(); }

interface IHas
{
    associatedtype Elem : IArith;
    Elem get();
}

struct IntElem : IArith { int v; int toInt() { return v; } }

struct Holder : IHas
{
    typealias Elem = IntElem;
    Elem get() { IntElem e; e.v = 9; return e; }
}

int read<T : IHas>(T t)
{
    T.Elem e = t.get();
    return e.toInt();
}

void main()
{
    Holder h;
    // CHECK: r=9
    printf("r=%d\n", read(h));
}
