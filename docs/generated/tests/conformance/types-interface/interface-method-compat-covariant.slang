//META: generated=true
//META: doc_ref=docs/language-reference/types-interface.md#description
//META: purpose=A member function implementation is compatible with an interface requirement when the impl function can be called with the interface parameter types and the return type is convertible to the interface return type; wider parameter types and narrower return types are accepted.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the method compatibility rule: an implementation is accepted when its
// parameters are wider than the requirement's (so callers can pass narrower values)
// and its return type is narrower than the requirement's (so it converts up).
// Test mirrors the Remark 1 example: interface requires int32_t someFunc(int8_t, int16_t),
// impl uses int16_t someFunc(int, int32_t); CHECK asserts result=7.

//TEST:INTERPRET(filecheck=CHECK):

interface IBase
{
    int32_t someFunc(int8_t a, int16_t b);
}

struct Test : IBase
{
    // Compatible: int16_t (impl) -> int32_t (interface) is OK
    // int (impl param) accepts int8_t (interface param) is OK
    int16_t someFunc(int a, int32_t b)
    {
        return int16_t(a + b);
    }
}

void main()
{
    Test obj;
    int32_t result = obj.someFunc(int8_t(3), int16_t(4));
    //CHECK: result=7
    printf("result=%d\n", result);
}
