//META: generated=true
//META: doc_ref=docs/language-reference/types-extension.md#struct
//META: purpose=Doc Example 3 (struct): an `extension TestClass : IReq` ADDS a new interface conformance to a struct that did not originally declare it.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Unlike Example 2 (where the struct declared `: IReq` but didn't
// implement), here the struct does NOT declare conformance at
// definition. The extension adds both the conformance and the
// implementation.

//TEST:INTERPRET(filecheck=CHECK):

interface IReq
{
    int requiredFunc();
}

struct TestClass
{
}

extension TestClass : IReq
{
    int requiredFunc()
    {
        return 42;
    }
}

void main()
{
    TestClass concrete = {};
    int r = concrete.requiredFunc();
    //CHECK: r=42
    printf("r=%d\n", r);
}
