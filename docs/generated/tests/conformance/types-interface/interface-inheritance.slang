//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may inherit from another interface; inherited members add to the inheriting interface, and a concrete type conforming to the child interface must satisfy all inherited requirements.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that conforming to a child interface requires satisfying all
// inherited parent requirements as well. Impl conforms to IDerived : IBase
// and must supply getA() (from IBase) and getB() (from IDerived); CHECK
// asserts both accessors return correct values.

//TEST:INTERPRET(filecheck=CHECK):

interface IBase
{
    int getA();
    static const int8_t bias;
}

interface IDerived : IBase
{
    int getB();
}

struct Impl : IDerived
{
    static const int8_t bias = 2;
    int _a;
    int _b;

    int getA() { return _a + bias; }
    int getB() { return _b; }
}

void main()
{
    Impl obj;
    obj._a = 10;
    obj._b = 20;
    //CHECK: a=12 b=20
    printf("a=%d b=%d\n", obj.getA(), obj.getB());
}
