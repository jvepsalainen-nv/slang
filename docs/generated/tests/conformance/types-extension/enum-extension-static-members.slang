//META: generated=true
//META: doc_ref=docs/language-reference/types-extension.md#enum
//META: purpose=An `extension` of an enum adds static data and static functions accessed via `EnumType.member`.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

//TEST:INTERPRET(filecheck=CHECK):

enum TestEnum { V1 = 1, V2, V3, V4 }

extension TestEnum
{
    static int staticValue = 42;
    static int staticFunction() { return 123; }
}

void main()
{
    int sv = TestEnum.staticValue;
    int sf = TestEnum.staticFunction();
    //CHECK: sv=42 sf=123
    printf("sv=%d sf=%d\n", sv, sf);
}
