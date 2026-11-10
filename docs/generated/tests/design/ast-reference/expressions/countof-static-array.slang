//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that `countof(e)` on a static array yields the array's element count.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The element-count operand is documented to accept an array as well as a
// pack. Two arrays of different lengths and different element types are
// probed so a result that tracks the element size instead of the length is
// distinguishable from the correct answer; the CHECKs assert the lengths.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a[9];
    double b[6];
    // CHECK: a=9
    printf("a=%d\n", countof(a));
    // CHECK: b=6
    printf("b=%d\n", countof(b));
}
