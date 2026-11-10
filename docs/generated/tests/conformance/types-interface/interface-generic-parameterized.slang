//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=An interface may be parameterized with generics; a struct conforms by providing a concrete type argument.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a struct can conform to a generic interface instantiated with
// a concrete type argument. TestClass conforms to ITypedReq<uint> and its
// someFunc adds 123 to the parameter; CHECK asserts result=130, proving the
// generic interface was correctly specialised and dispatched.

//TEST:INTERPRET(filecheck=CHECK):

interface ITypedReq<T>
{
    T someFunc(T param);
}

struct TestClass : ITypedReq<uint>
{
    uint someFunc(uint param)
    {
        return 123 + param;
    }
}

void main()
{
    TestClass obj;
    uint res = obj.someFunc(7);
    //CHECK: result=130
    printf("result=%d\n", res);
}
