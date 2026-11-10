//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/keywords-and-builtins.md#decl-keywords
//META: purpose=`interface` is the decl keyword that declares a protocol-style requirement set; a `struct` conforms via `:` and supplies the required member.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Declare an interface, conform a struct to it, and dispatch via a
// generic function constrained by that interface. The result proves
// `interface` is bound to its documented role and that the parser
// accepts the conformance clause.

//TEST:INTERPRET(filecheck=CHECK):

interface IAnswer
{
    int get();
}

struct Forty : IAnswer
{
    int get() { return 40; }
}

int call<T : IAnswer>(T t) { return t.get() + 2; }

void main()
{
    Forty f;
    // CHECK: r=42
    printf("r=%d\n", call(f));
}
