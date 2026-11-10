//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#syntax
//META: purpose=The `++` (prefix increment) operator on a pointer advances it by one element; `--` retreats by one element.
//META: intent=boundary
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `++` and `--` on a pointer each step by exactly one element.
// Increments from arr[0] to arr[1], reads the value, then decrements back;
// CHECK asserts both reads are correct, confirming step size is element-wise
// in both directions.
//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int arr[3] = { 100, 200, 300 };
    int* p = &arr[0];
    ++p;                  // advance to arr[1]
    int a = *p;           // 200
    --p;                  // back to arr[0]
    int b = *p;           // 100
    //CHECK: 200 100
    printf("%d %d\n", a, b);
}
