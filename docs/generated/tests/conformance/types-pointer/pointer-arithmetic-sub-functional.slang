//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=Subtracting an integer `n` from a pointer-to-array-element yields a pointer `n` elements back; the resulting pointer dereferences to the correct element.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that subtracting an integer from a pointer retreats by that many elements.
// Points to the last element of a 5-element array, subtracts 3, dereferences;
// CHECK asserts the value at the retreated position, proving subtraction is element-wise.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int arr[5] = { 5, 10, 15, 20, 25 };
    int* p = &arr[4];
    p = p - 3;
    //CHECK: 10
    printf("%d\n", *p);
}
