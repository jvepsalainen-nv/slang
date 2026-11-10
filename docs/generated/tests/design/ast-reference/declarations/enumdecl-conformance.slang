//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#enumdecl-and-enumcasedecl
//META: purpose=An EnumDecl is an aggregate type declaration, so an enum can be given an interface conformance and dispatched through a constrained generic.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that an enum participates in the same conformance machinery as a
// struct. An extension adds an interface conformance to the enum, and an
// interface-constrained generic is called with an enum value; the CHECK
// asserts the value the conformance's method returns for that case.

//TEST:INTERPRET(filecheck=CHECK):

interface IRanked { int rank(); }

enum Color { Red, Green, Blue }

extension Color : IRanked
{
    int rank()
    {
        if (this == Color::Red)   return 1;
        if (this == Color::Green) return 2;
        return 3;
    }
}

int dispatch<T : IRanked>(T x) { return x.rank(); }

void main()
{
    //CHECK: 2
    printf("%d\n", dispatch(Color::Green));
}
