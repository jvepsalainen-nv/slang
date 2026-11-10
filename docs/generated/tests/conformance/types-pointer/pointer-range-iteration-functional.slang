//META: generated=true
//META: doc_ref=docs/language-reference/types-pointer.md#examples
//META: purpose=Pointer range iteration `[start, end)` using `p != end; ++p` traverses all elements of an array; the past-end pointer `&arr[N-1] + 1` is a valid sentinel.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a half-open pointer range `[start, end)` with a past-the-end sentinel
// iterates all elements exactly once. `sumRange` accumulates elements by walking
// `start != end; ++start`; CHECK asserts the total equals the known array sum,
// confirming both past-end pointer validity and the iteration pattern.
//TEST:INTERPRET(filecheck=CHECK):

uint sumRange(uint* start, uint* end)
{
    uint sum = 0;
    for (uint* i = start; i != end; ++i)
        sum = sum + *i;
    return sum;
}

void main()
{
    uint arr[5] = { 1, 2, 3, 4, 5 };
    uint* start = &arr[0];
    uint* end   = &arr[4] + 1;   // one past last — valid sentinel per doc
    uint result = sumRange(start, end);
    //CHECK: 15
    printf("%d\n", result);
}
