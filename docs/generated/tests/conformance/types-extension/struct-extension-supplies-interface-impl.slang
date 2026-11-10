//META: generated=true
//META: doc_ref=docs/language-reference/types-extension.md#struct
//META: purpose=Doc Example 2 (struct): a struct declares conformance to an interface (`: IReq`) but does NOT implement the requirement inline; an `extension` supplies the implementation.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

interface IReq
{
    int requiredFunc();
}

struct TestClass : IReq
{
}

extension TestClass
{
    int requiredFunc()
    {
        return 42;
    }
}

void main()
{
    TestClass obj = {};
    int r = obj.requiredFunc();
    //CHECK: r=42
    printf("r=%d\n", r);
}
