//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#implicit-scopes
//META: purpose=The `associatedtype A where A : IBar` where-clause form places its GenericTypeConstraintDecl in the enclosing interface's scope like the inheritance-clause form, so generic code can call IBar's requirement on T.A.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the second constraint surface form: the where-clause on the
// associatedtype produces the same interface-scope requirement member as
// the inheritance-clause spelling. The generic call through T.A.tag()
// succeeds only if the where-clause constraint registered.

//TEST:INTERPRET(filecheck=CHECK):

interface IBar
{
    static int tag();
}

interface IHasA
{
    associatedtype A where A : IBar;
}

struct Bar8 : IBar
{
    static int tag() { return 8; }
}

struct HasA : IHasA
{
    typealias A = Bar8;
}

int readTag<T : IHasA>()
{
    return T.A.tag();
}

void main()
{
    int t = readTag<HasA>();
    // CHECK: t=8
    printf("t=%d\n", t);
}
