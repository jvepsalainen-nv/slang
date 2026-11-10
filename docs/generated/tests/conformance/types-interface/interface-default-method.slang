//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface member function with an implementation body provides a default; the conforming struct inherits it without overriding.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a concrete struct inherits a default method from its interface
// without needing to override it. MyStruct only supplies base(); the interface
// default doubled() delegates to base(). CHECK asserts doubled=14, which is
// only reachable if the default body executes on the concrete type.

//TEST:INTERPRET(filecheck=CHECK):

interface IWithDefault
{
    int base();
    int doubled() { return base() * 2; }
}

struct MyStruct : IWithDefault
{
    int _v;
    int base() { return _v; }
}

void main()
{
    MyStruct s;
    s._v = 7;
    //CHECK: doubled=14
    printf("doubled=%d\n", s.doubled());
}
