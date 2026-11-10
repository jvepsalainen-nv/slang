//META: generated=true
//META: doc_ref=docs/language-reference/types-extension.md#enum
//META: purpose=Inside a non-static member function added by an enum extension, `this` is the value of the enumeration object.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that inside a non-static method added via an enum extension,
// `this` holds the enumerator's integer value. `times2()` returns
// `int(this) * 2`; calling it on V1 and V3 produces 2 and 6, which
// CHECK asserts — only possible if `this` resolved to the correct value.

//TEST:INTERPRET(filecheck=CHECK):

enum TestEnum { V1 = 1, V2 = 2, V3 = 3, V4 = 4 }

extension TestEnum
{
    int times2() { return int(this) * 2; }
}

void main()
{
    TestEnum v1 = TestEnum.V1;
    TestEnum v3 = TestEnum.V3;
    int a = v1.times2();
    int b = v3.times2();
    //CHECK: a=2 b=6
    printf("a=%d b=%d\n", a, b);
}
