//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/lookup.md#interface-requirements-vs-default-implementations
//META: purpose=A conforming type's implementation of a requirement wins over the interface's default implementation of the same requirement.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a witness override shadows the default body. IGreet
// supplies a default `hello()` returning 1 and A overrides it with 99;
// the generic call goes through the interface, so only the witness
// decides which body runs. CHECK asserts 99, which distinguishes the
// override from the default.

//TEST:INTERPRET(filecheck=CHECK):

interface IGreet
{
    int hello() { return 1; }
}

struct A : IGreet
{
    override int hello() { return 99; }
}

int callIt<T : IGreet>(T t) { return t.hello(); }

void main()
{
    A a;
    // CHECK: g=99
    printf("g=%d\n", callIt(a));
}
