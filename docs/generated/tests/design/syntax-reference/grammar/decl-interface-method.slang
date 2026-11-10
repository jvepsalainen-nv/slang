//META: generated=true
//META: doc_ref=docs/generated/design/syntax-reference/grammar.md#type-defining-declarations
//META: purpose=`InterfaceDecl` parses as `'interface' IDENT '{' InterfaceMember* '}'` and accepts a FuncDecl member.
//META: intent=functional
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the InterfaceDecl production with a FuncDecl member as the
// `InterfaceMember`. A struct conforms to the interface and we observe
// the call resolves to its implementation.

//TEST:INTERPRET(filecheck=CHECK):

interface IPing
{
    int ping();
}

struct A : IPing
{
    int ping() { return 5; }
}

void main()
{
    A a;
    // CHECK: ping=5
    printf("ping=%d\n", a.ping());
}
