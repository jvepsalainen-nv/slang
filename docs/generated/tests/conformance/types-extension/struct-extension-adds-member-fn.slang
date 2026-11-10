//META: generated=true
//META: doc_ref=docs/language-reference/types-extension.md#struct
//META: purpose=Doc Example 1 (struct): an `extension` adds a member function to a previously-defined struct; the function is callable on instances of the original struct.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Direct port of the doc's Example 1 for struct extensions.

//TEST:INTERPRET(filecheck=CHECK):

struct ExampleStruct
{
    int a;

    int getASquared()
    {
        return a * a;
    }
}

extension ExampleStruct
{
    [mutating] void addToA(int x)
    {
        a = a + x;
    }
}

void main()
{
    ExampleStruct s = { 3 };
    int sq = s.getASquared();
    s.addToA(10);
    //CHECK: sq=9 a=13
    printf("sq=%d a=%d\n", sq, s.a);
}
