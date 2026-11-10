//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=Interface member functions may be static or non-static; a static method requirement is satisfied by a static method on the conforming struct.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a static method requirement in an interface is satisfied by
// a matching static method on the conforming struct. WidgetFactory.create()
// returns 99; CHECK asserts this value, confirming the static conformance path
// compiles and dispatches correctly.

//TEST:INTERPRET(filecheck=CHECK):

interface IFactory
{
    static int create();
}

struct WidgetFactory : IFactory
{
    static int create() { return 99; }
}

void main()
{
    //CHECK: created=99
    printf("created=%d\n", WidgetFactory.create());
}
